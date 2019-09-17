import React from "react";
import {
  NativeModules,
  requireNativeComponent,
  DeviceEventEmitter,
  Platform
} from "react-native";
// import BubblePicke from './BubblePickerView';
const { RNBubblePicker } = NativeModules;

export default { ...RNBubblePicker };

const BubblePickerView = Platform.select({
  android: requireNativeComponent("BubblePickerView", null),
  ios: requireNativeComponent("RNBubblePicker", null)
});

export class BubblePicker extends React.Component {
  constructor(props) {
    super(props);
    this._onChange = this._onChange.bind(this);
  }

  componentDidMount() {
    this.subscription = DeviceEventEmitter.addListener(
      "onSelected",
      this._onChange
    );
    this.subscription2 = DeviceEventEmitter.addListener(
      "onDeselected",
      this._onChange
    );
  }
  componentWillUnmount() {
    this.subscription.remove();
    this.subscription2.remove();
  }

  _onChange(event) {
    if (!this.props.onPress) {
      return;
    }
    Platform.select({
      ios: () => this.props.onPress(event.nativeEvent),
      android: () => this.props.onPress(event)
    })();
  }
  render() {
    return (
      <BubblePickerView
        {...this.props}
        onSelected={this._onChange}
        onDeselected={this._onChange}
      />
    );
  }
}
