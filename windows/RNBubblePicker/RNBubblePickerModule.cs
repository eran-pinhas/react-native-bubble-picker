using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Bubble.Picker.RNBubblePicker
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNBubblePickerModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNBubblePickerModule"/>.
        /// </summary>
        internal RNBubblePickerModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNBubblePicker";
            }
        }
    }
}
