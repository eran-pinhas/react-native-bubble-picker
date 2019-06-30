export default 3
// import { requireNativeComponent } from 'react-native';
// import React from 'react'
// const BubblePickerView = requireNativeComponent('BubblePickerView',null)

// export default class BubblePicker extends React.Component {
//   constructor(props) {
//     super(props);
//     this._onChange = this._onChange.bind(this);
//   }
//   _onChange(event) {
//     if (!this.props.onPress) {
//       return;
//     }
//     this.props.onPress(event.nativeEvent.message);
//   }
//   render() {
//     return <BubblePickerView {...this.props} onSelected={this._onChange} onDeselected={this._onChange} />;
//   }
// }