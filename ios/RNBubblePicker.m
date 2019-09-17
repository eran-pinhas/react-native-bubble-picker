#import <React/RCTViewManager.h>

@interface RCT_EXTERN_REMAP_MODULE(RNBubblePicker, RNBubblePickerViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(items, NSArray<NSDictionary *>)
RCT_EXPORT_VIEW_PROPERTY(radius, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(fontSize, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(onSelected, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDeselected, RCTDirectEventBlock)

    
@end
