import UIKit
import SpriteKit
import Foundation

import SIFloatingCollection


extension CGFloat {
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

class BubblesScene: SIFloatingCollectionScene {
    var bottomOffset: CGFloat = 200
    var topOffset: CGFloat = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    fileprivate func configure() {
        backgroundColor = SKColor.white
        scaleMode = .aspectFill
        allowMultipleSelection = true
        allowEditing = true
        var bodyFrame = frame
        bodyFrame.size.width = CGFloat(magneticField.minimumRadius)
        bodyFrame.origin.x -= bodyFrame.size.width / 2
        bodyFrame.size.height = frame.size.height - bottomOffset
        bodyFrame.origin.y = frame.size.height - bodyFrame.size.height - topOffset
        physicsBody = SKPhysicsBody(edgeLoopFrom: bodyFrame)
        magneticField.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 + bottomOffset / 2 - topOffset)
    }
    
    override func addChild(_ node: SKNode) {
        if node is BubbleNode {
            var x = CGFloat.random(min: -bottomOffset, max: -node.frame.size.width)
            let y = CGFloat.random(
                min: frame.size.height - bottomOffset - node.frame.size.height,
                max: frame.size.height - topOffset - node.frame.size.height
            )
            
            if floatingNodes.count % 2 == 0 || floatingNodes.isEmpty {
                x = CGFloat.random(
                    min: frame.size.width + node.frame.size.width,
                    max: frame.size.width + bottomOffset
                )
            }
            node.position = CGPoint(x: x, y: y)
        }
        super.addChild(node)
    }
    
    func performCommitSelectionAnimation() {
        let currentPhysicsSpeed = physicsWorld.speed
        physicsWorld.speed = 0
        let sortedNodes = sortedFloatingNodes()
        var actions: [SKAction] = []
        
        for node in sortedNodes {
            node.physicsBody = nil
            let action = actionForFloatingNode(node)
            actions.append(action)
        }
        run(SKAction.sequence(actions)) { [weak self] in
            self?.physicsWorld.speed = currentPhysicsSpeed
        }
    }
    
    func sortedFloatingNodes() -> [SIFloatingNode] {
        return floatingNodes.sorted { (node: SIFloatingNode, nextNode: SIFloatingNode) -> Bool in
            let distance = self.distance(magneticField.position,node.position)
            let nextDistance = self.distance(nextNode.position, magneticField.position)
            return distance < nextDistance && node.state != .selected
        }
    }
    
    func actionForFloatingNode(_ node: SIFloatingNode!) -> SKAction {
        let action = SKAction.run { [unowned self] () -> Void in
            if let index = self.floatingNodes.index(of: node) {
                self.removeFloatingNode(at: index)
                
                if node.state == .selected {
                    let destinationPoint = CGPoint(x: self.size.width / 2, y: self.size.height + 40)
                    (node as? BubbleNode)?.throw(to: destinationPoint) {
                        node.removeFromParent()
                    }
                }
            }
        }
        return action
    }
}

class BubbleItem {
    var isSelected:Bool
    var textColor: String
    var id: String
    var text: String
    var color: String
    
    init(_ item: NSDictionary){
        isSelected = item["isSelected"] as! Bool
        textColor = item["textColor"] as! String
        id = item["id"] as! String
        text = item["text"] as! String
        color = item["color"] as! String
    }
    
    func toDict()-> Dictionary<String, Any>{
        var ret = Dictionary<String, Any>()
        ret["isSelected"] = self.isSelected
        ret["textColor"] = self.textColor
        ret["id"] = self.id
        ret["text"] = self.text
        ret["color"] = self.color
        return ret
    }
}


class RNBubblePickerView: SKView, SIFloatingCollectionSceneDelegate {
    
    // props
    @objc var items: NSArray! = [] {didSet { self.updateItems() }}
    @objc var radius: CGFloat = 30 {didSet { self.updateItems() }}
    @objc var fontSize: CGFloat = 10 {didSet { self.updateItems() }}
    // callback events
    @objc var onSelected: RCTDirectEventBlock?
    @objc var onDeselected: RCTDirectEventBlock?
    
    // state
    private var floatingCollectionScene: BubblesScene!
    var loaded = false
    
    @objc func floatingScene(_ scene: SIFloatingCollectionScene, didSelectFloatingNodeAt index: Int) {
        if let node = scene.floatingNodes[index] as? BubbleNode, let onSelectedEmitter = onSelected  {
            for itemDict in (items as! [NSDictionary]){
                let item = BubbleItem(itemDict)
                if item.id == node.id {
                    item.isSelected = true
                    node.state = .normal
                    onSelected!(item.toDict())
                }
            }
        }
    }
    
    @objc func floatingScene(_ scene: SIFloatingCollectionScene, didDeselectFloatingNodeAt index: Int){
        if let node = scene.floatingNodes[index] as? BubbleNode, let onDeselectedEmitter = onDeselected  {
            for itemDict in (items as! [NSDictionary]){
                let item = BubbleItem(itemDict)
                if item.id == node.id {
                    item.isSelected = false
                    node.state = .selected
                    onDeselected!(item.toDict())
                    // the chnage should come from the props
                }
            }
        }
    }
    func hexToColor(_ hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt32 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return UIColor() }
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return UIColor()
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func createNode(_ id: String) -> BubbleNode {
        let newNode = BubbleNode.instantiate(radius: radius, fontSize: fontSize)
        floatingCollectionScene.addChild(newNode)
        newNode.id = id;
        return newNode
    }
    
    func updateItems(){
        if !loaded { return }
        
        var itemsDone:[String:Bool] = [String:Bool]()
        
        for itemDict in (items as! [NSDictionary]){
            let item = BubbleItem(itemDict)
            var fouldItemsNode :BubbleNode?;
   
            // looping threw all bubbles looking for our bubble
            for node in floatingCollectionScene.floatingNodes{
                if let currBubbleNode = node as? BubbleNode {
                    if currBubbleNode.id == item.id {
                        fouldItemsNode = currBubbleNode
                        break
                    }
                }
            }
            
            // No bubble found for this id
            let itemsNode:BubbleNode = fouldItemsNode == nil ? createNode(item.id) : fouldItemsNode as! BubbleNode
            
            // Setting display
            itemsNode.setDisplay(text: item.text, textColor:hexToColor(item.textColor), fillColor:hexToColor(item.color),radius: radius, fontSize: fontSize)
            
            // Setting isSelected
            // Denote - there is 3rd state posible - .removing
            if itemsNode.state == .selected && !item.isSelected {
                // deselecting
                itemsNode.state = .normal
            } else if itemsNode.state == .normal && item.isSelected {
                // selecting
                itemsNode.state = .selected
            }
            
            itemsDone[item.id] = true
        }
        
        // looping threw all bubbles - looking for bubbles that should be removed
        var toRemove = [BubbleNode]()
        for node in floatingCollectionScene.floatingNodes{
            if let currBubbleNode = node as? BubbleNode {
                if itemsDone[currBubbleNode.id] == nil {
                    toRemove.append(currBubbleNode)
                }
            }
        }
        for node in toRemove {
            if let index = floatingCollectionScene.floatingNodes.index(of: node){
                floatingCollectionScene.removeFloatingNode(at: index)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        floatingCollectionScene = BubblesScene(size: self.bounds.size)
        floatingCollectionScene.floatingDelegate = self
        self.presentScene(floatingCollectionScene)
        loaded = true
        self.updateItems()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder:aDecoder)
    }
}

