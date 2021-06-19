# ironsource_mediation

Flutter bridge for ironSource Mediation SDK.

- [Android SDK: 7.1.6](https://developers.ironsrc.com/ironsource-mobile/android/android-sdk/)
- [iOS SDK: 7.1.6.1.0](https://developers.ironsrc.com/ironsource-mobile/ios/ios-sdk/)

# Getting Started

## Android

Follow [ironSource Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/android/android-sdk/) Android integration guide.

### Gradle dependencies included

- ironSource SDK
- Google Play Services play-services-ads-identifier
- Google Play Services play-services-basement

### AndroidManifest.xml

After adding the plugin to the pubspec.yml, Android build fails with the error below:

```
Attribute application@label value=(your_app_label) from AndroidManifest.xml:11:9-40
  is also present at [com.ironsource.sdk:mediationsdk:7.1.6] AndroidManifest.xml:15:9-41 value=(@string/app_name).
```

To prevent this, do the following:

- Add `xmls:tools` to AndroidManifest.xml of your project.
- Add `tools:replace="android:label"` to the `application` tag.

## iOS

Follow [ironSource Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/ios/ios-sdk/) iOS integration guide.

### Pods included

- ironSource SDK

### Additional Requirements

#### <ins>SKAdNetwork Support</ins>

Add the SKAN ID of ironSource Network on info.plist

```xml
<key>SKAdNetworkItems</key>
<array>
   <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>su67r6k2v3.skadnetwork</string>
   </dict>
</array>
```

#### <ins>App Transport Security Settings</ins>

Set [NSAllowsArbitraryLoads](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsallowsarbitraryloads): `true` on info.plist to allow http

Note:

- Make sure that your info.plist does not contain other ATS exceptions such as [NSAllowsArbitraryLoadsInWebContent](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsallowsarbitraryloadsinwebcontent).

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

## Usage

### Implement Listeners

```dart
class SomeFlutterClass with IronSourceRewardedVideoListener {
  /// RV listener
  @override
  void onRewardedVideoAdClicked(IronSourceRVPlacement placement) {
    print('onRewardedVideoAdClicked Placement:${placement}');
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdEnded() {
    print("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdOpened() {
    print("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(IronSourceRVPlacement placement) {
    print("onRewardedVideoAdRewarded Placement: ${placement}");
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    print("onRewardedVideoAdShowFailed Error:${error}");
  }

  @override
  void onRewardedVideoAdStarted() {
    print("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool isAvailable) {
    print('onRewardedVideoAvailabilityChanged: $isAvailable');
    // Change the RV show button active state
  }
}
```

### Initialize the SDK

```dart
Future<void> initIronSource() async {
  final appKey = Platform.isAndroid
      ? ANDROID_APP_KEY
      : Platform.isIOS
          ? IOS_APP_KEY
          : throw Exception("Unsupported Platform");
  try {
    IronSource.validateIntegration();
    IronSource.setRVListener(this);
    await IronSource.setAdaptersDebug(true);
    await IronSource.shouldTrackNetworkState(true);

    String id = await IronSource.getAdvertiserId(); // GAID, IDFA
    await IronSource.setUserId(id.isNotEmpty ? id : _FALLBACK_USER_ID);
    await IronSource.init(appKey: appKey, adUnits: [IronSourceAdUnit.RewardedVideo]);
  } on PlatformException catch (e) {
    print(e);
  }
}
```

### Show Ads

```dart
Future<void> showRVOnClick() async {
  if (await IronSource.isRewardedVideoAvailable()) {
    IronSource.showRewardedVideo();
  }
}
```

Refer to the [example app](./example) for the more detailed implementation sample.

Note:

- Make sure to read the official documents at [ironSource Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/android/android-sdk/) for proper usage.
- Some config functions must be called before `IronSource.init`.

### Banner Positioning

For the native SDKs, a banner view must be implemented directly to the UI component.
This bridge takes care of native level view implementation. Therefore, positioning parameters are provided as below:

#### Position

```dart
enum IronSourceBannerPosition {
  Top,
  Center,
  Bottom,
}
```

#### Offset

This parameter represents the vertical offset of the banner:

- Negative values: Upward offset
- Positive values: Downward offset

Unit:

- Android: dp
- iOS: point

Note:

- Offset in the same direction of the position will be ignored. e.g. Bottom & 50, Top & -50
- However, the offsets in the opposite direction or both directions on the Center position can go beyond the screen boundaries. e.g. Bottom & -10000
- Make sure that a banner presented will be visible

```dart
IronSource.loadBanner(
  size: IronSourceBannerSize.BANNER,
  position: IronSourceBannerPosition.Bottom,
  verticalOffset: -50, // adding 50dp/50point margin bottom
  placementName: 'DefaultBanner');
```

## Naming Convention

The MethodChannel and Listener functions are named mostly after the corresponding ironSource Android SDK functions.

## Functions Not Supported

Some functions are not supported.

- `initISDemandOnly`
- `setLanguage`
- `SegmentListener: onSegmentReceived`
- `showISDemandOnlyRewardedVideo`
- `loadISDemandOnlyRewardedVideo`
- `isISDemandOnlyRewardedVideoAvailable`
- `loadISDemandOnlyInterstitial`
- `showISDemandOnlyInterstitial`
- `isISDemandOnlyInterstitialReady`

# Mediation

Many networks require certain additional configuration.
Make sure to use compatible Adapter versions.

## Android

Make sure to follow [ironSource Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/android/mediation-networks-android/) document for additional setup.

- Add dependencies to `PROJECT/android/app/build.gradle`
- Add required settings to `PROJECT/android/app/src/main/AndroidManifest.xml`

## iOS

Make sure to follow [ironSource Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/ios/mediation-networks-ios/) document for additional setup.

- Add pod dependencies to `PROJECT/ios/Podfile: target 'Runner'`
- Add required settings to `PROJECT/ios/Runner/info.plist`

Note:

- For Podfile, adding `use_frameworks!` results in the [transitive dependencies error](https://github.com/flutter/flutter/issues/20045).
