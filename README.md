
# react-native-bubble-picker

## Getting started

`$ npm install react-native-bubble-picker --save`

### Mostly automatic installation

`$ react-native link react-native-bubble-picker`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-bubble-picker` and add `RNBubblePicker.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBubblePicker.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNBubblePickerPackage;` to the imports at the top of the file
  - Add `new RNBubblePickerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-bubble-picker'
  	project(':react-native-bubble-picker').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-bubble-picker/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-bubble-picker')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNBubblePicker.sln` in `node_modules/react-native-bubble-picker/windows/RNBubblePicker.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Bubble.Picker.RNBubblePicker;` to the usings at the top of the file
  - Add `new RNBubblePickerPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNBubblePicker from 'react-native-bubble-picker';

// TODO: What to do with the module?
RNBubblePicker;
```
  