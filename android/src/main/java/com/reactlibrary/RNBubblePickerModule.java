
package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import java.util.Arrays;
import java.util.List;

public class RNBubblePickerModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNBubblePickerModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNBubblePicker";
  }

    //@Override
    //protected List<ReactPackage> getPackages() {
    //    return Arrays.<ReactPackage>asList(
    //            new MainReactPackage(),
    //            new VideoViewPackage()
    //    );
    //}

  @ReactMethod
  public void show(String message, int duration,final Promise promise) {
      promise.resolve("3");
  }


}