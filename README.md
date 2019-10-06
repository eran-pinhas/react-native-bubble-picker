# react-native-bubble-picker

## Getting started

`$ npm install react-native-bubble-picker --save`

### Mostly automatic installation (RN < 0.60)

`$ react-native link react-native-bubble-picker`

### Manual installation

## Usage

```javascript
import { BubblePicker } from "react-native-bubble-picker";

//...

onBubblePress = e => {
  const { isSelected, id } = e;

  // Do stuff to save the set the bubble as selected
};
//...

const items = ["Option 1", "Option 2", "Option 3"].map(name => ({
  text: name,
  color: "#888888",
  textColor: "#ffffff",
  isSelected: selectled.indexOf(x.id) > -1,
  id: name
}));

const PickerProps = Platform.select({
  android: {
    radius: 5,
    fontSize: 10
  },
  ios: {
    radius: 50,
    fontSize: 16
  }
});

// rendering:
<FullScreenBubblePicker
  {...PickerProps}
  items={items}
  onPress={this.onBubblePress}
/>;
```
