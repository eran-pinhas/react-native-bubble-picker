
import Foundation

import UIKit
import SpriteKit

import SIFloatingCollection

class SKMultilineLabel: SKNode {
    //props
    var labelWidth:Int {didSet {update()}}
    var labelHeight:Int = 0
    var text:String {didSet {update()}}
    var fontSize:CGFloat {didSet {update()}}
    var pos:CGPoint {didSet {update()}}
    var fontColor:UIColor {didSet {update()}}
    var leading:Double {didSet {update()}}
    var alignment:SKLabelHorizontalAlignmentMode {didSet {update()}}
    var dontUpdate = false
    var shouldShowBorder:Bool = false {didSet {update()}}
    //display objects
    var rect:SKShapeNode?
    var labels:[SKLabelNode] = []
    
    init(text:String, labelWidth:Int, pos:CGPoint = CGPoint.zero, fontName:String? = nil, fontSize:CGFloat? = nil, fontColor:UIColor = UIColor.white, leading:Double? = nil, alignment:SKLabelHorizontalAlignmentMode = .center, shouldShowBorder:Bool = false)
    {
        self.text = text
        self.labelWidth = labelWidth
        self.pos = pos;
        self.fontSize = fontSize ?? 11;
        self.fontColor = fontColor
        self.leading = leading ?? Double(fontSize ?? 11);
        self.shouldShowBorder = shouldShowBorder
        self.alignment = alignment
        
        super.init()
        
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getSize(string: String, font: UIFont) -> CGSize {
        return (string as NSString).size(withAttributes: [NSAttributedString.Key.font: font]);
    }
    
    
    //if you want to change properties without updating the text field,
    //  set dontUpdate to false and call the update method manually.
    func update() {
        if (dontUpdate) {return}
        if (labels.count>0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        let words = (text as NSString).components(separatedBy: NSCharacterSet.whitespacesAndNewlines).filter { (word) -> Bool in
            return word.trimmingCharacters(in: .whitespacesAndNewlines).count>0;
        }
        var label = createLabel();
        let font = UIFont.systemFont(ofSize: fontSize);
        for word in words {
            let newText =  (label.text! + " ") + word.trimmingCharacters(in: .whitespacesAndNewlines);
            if (getSize(string: newText, font: font).width > CGFloat(labelWidth) && label.text != "") {
                labels.append(label);
                label = createLabel();
                label.text = word.trimmingCharacters(in: .whitespacesAndNewlines);
            }
            else {
                label.text = newText;
            }
        }
        labels.append(label);
        var wordLineNumber : Double = 0;
        for label in labels {
            var linePos = pos;
            if (alignment == .left) {
                linePos.x -= CGFloat(labelWidth / 2)
            } else if (alignment == .right) {
                linePos.x += CGFloat(labelWidth / 2)
            }
            let labelYFix = leading*0.5*Double(labels.count-2);
            linePos.y = CGFloat(-(leading*wordLineNumber)+labelYFix);
            label.position = CGPoint(x:linePos.x, y:linePos.y)
            self.addChild(label);
            wordLineNumber+=1;
        }
        
        labelHeight = Int(Double(labels.count) * leading)
        showBorder()
    }
    
    func createLabel() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: UIFont.systemFontSize).fontName)
        label.horizontalAlignmentMode = alignment
        label.fontSize = fontSize
        label.fontColor = fontColor
        label.text = ""
        return label;
    }
    
    func showBorder() {
        if (!shouldShowBorder) {return}
        if let rect = self.rect {
            self.removeChildren(in: [rect])
        }
        self.rect = SKShapeNode(rectOf: CGSize(width: labelWidth, height: labelHeight))
        if let rect = self.rect {
            rect.strokeColor = UIColor.white
            rect.lineWidth = 1
            rect.position = CGPoint(x: pos.x, y: pos.y - (CGFloat(labelHeight) / 2.0))
            self.addChild(rect)
        }
        
    }
}


class BubbleNode: SIFloatingNode {
    public var id: String = ""
    
    var labelNode:SKMultilineLabel? // SKLabelNode(fontNamed: "")
    
    class func instantiate(radius: CGFloat, fontSize: CGFloat ) -> BubbleNode {
        let node = BubbleNode(circleOfRadius: radius)
        configureNode(node, fontSize: fontSize, radius: radius)
        return node
    }
    
    class func configureNode(_ node: BubbleNode, fontSize: CGFloat, radius: CGFloat) {
        let boundingBox = node.path?.boundingBox;
        let radius = (boundingBox?.size.width)! / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        
        let labelNode = SKMultilineLabel(text: "", labelWidth: Int(radius * 1.5), fontName: "", fontSize: fontSize);
        labelNode.isUserInteractionEnabled = false
        node.addChild(labelNode);
        node.labelNode = labelNode
    }
    
    func setDisplay(text: String, textColor: SKColor, fillColor: SKColor, radius: CGFloat, fontSize: CGFloat) {
        if (self.labelNode !== nil){
            self.labelNode?.text = text
            self.fillColor = fillColor
            self.strokeColor = self.fillColor
            self.labelNode?.fontColor = textColor
            self.labelNode?.labelWidth = Int(radius * 1.5)
            self.labelNode?.fontSize = fontSize
        }
    }
    
    override func selectingAnimation() -> SKAction? {
        return SKAction.scale(to: 1.3, duration: 0.2)
    }
    
    override func normalizeAnimation() -> SKAction? {
        return SKAction.scale(to: 1, duration: 0.2)
    }
    
    override func removeAnimation() -> SKAction? {
        return SKAction.fadeOut(withDuration: 0.2)
    }
    
    override func removingAnimation() -> SKAction {
        let pulseUp = SKAction.scale(to: xScale + 0.13, duration: 0)
        let pulseDown = SKAction.scale(to: xScale, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        return repeatPulse
    }
    
    func `throw`(to point: CGPoint, completion block: @escaping (() -> Void)) {
        removeAllActions()
        let movingXAction = SKAction.moveTo(x: point.x, duration: 0.2)
        let movingYAction = SKAction.moveTo(y: point.y, duration: 0.4)
        let resize = SKAction.scale(to: 0.3, duration: 0.4)
        let throwAction = SKAction.group([movingXAction, movingYAction, resize])
        run(throwAction, completion: block)
    }
}
