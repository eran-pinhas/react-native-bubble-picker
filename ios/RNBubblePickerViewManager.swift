import Foundation

@objc(RNBubblePickerViewManager)
class RNBubblePickerViewManager: RCTViewManager {
    override func view() -> UIView! {
        return RNBubblePickerView(frame: CGRect.zero)
    }
    
    // this is required since RN 0.49+
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
