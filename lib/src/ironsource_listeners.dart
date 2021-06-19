import './ironsource_error.dart';
import './ironsource_rv_placement.dart';
import './ironsource_ow_credit_info.dart';
import './ironsource_impression_data.dart';

/// Ad Units ==================================================================

abstract class IronSourceRewardedVideoListener {
  /// Android: onRewardedVideoAdOpened
  ///     iOS: rewardedVideoDidOpen
  void onRewardedVideoAdOpened();

  /// Android: onRewardedVideoAdClosed
  ///     iOS: rewardedVideoDidClose
  void onRewardedVideoAdClosed();

  /// Android: onRewardedVideoAvailabilityChanged
  ///     iOS: rewardedVideoHasChangedAvailability
  void onRewardedVideoAvailabilityChanged(bool isAvailable);

  /// Android: onRewardedVideoAdRewarded
  ///     iOS: didReceiveRewardForPlacement
  void onRewardedVideoAdRewarded(IronSourceRVPlacement placement);

  /// Android: onRewardedVideoAdShowFailed
  ///     iOS: rewardedVideoDidFailToShowWithError
  void onRewardedVideoAdShowFailed(IronSourceError error);

  /// Android: onRewardedVideoAdClicked
  ///     iOS: didClickRewardedVideo
  void onRewardedVideoAdClicked(IronSourceRVPlacement placement);

  /// Android: onRewardedVideoAdStarted
  ///     iOS: rewardedVideoDidStart
  void onRewardedVideoAdStarted();

  /// Android: onRewardedVideoAdEnded
  ///     iOS: rewardedVideoDidEnd
  void onRewardedVideoAdEnded();
}

abstract class IronSourceInterstitialListener {
  /// Android: onInterstitialAdReady
  ///     iOS: interstitialDidLoad
  void onInterstitialAdReady();

  /// Android: onInterstitialAdLoadFailed
  ///     iOS: interstitialDidFailToLoadWithError
  void onInterstitialAdLoadFailed(IronSourceError error);

  /// Android: onInterstitialAdOpened
  ///     iOS: interstitialDidOpen
  void onInterstitialAdOpened();

  /// Android: onInterstitialAdClosed
  ///     iOS: interstitialDidClose
  void onInterstitialAdClosed();

  /// Android: onInterstitialAdShowSucceeded
  ///     iOS: interstitialDidShow
  void onInterstitialAdShowSucceeded();

  /// Android: onInterstitialAdShowFailed
  ///     iOS: interstitialDidFailToShowWithError
  void onInterstitialAdShowFailed(IronSourceError error);

  /// Android: onInterstitialAdClicked
  ///     iOS: didClickInterstitial
  void onInterstitialAdClicked();
}

abstract class IronSourceBannerListener {
  /// Android: onBannerAdLoaded
  ///     iOS: bannerDidLoad
  void onBannerAdLoaded();

  /// Android: onBannerAdLoadFailed
  ///     iOS: bannerDidFailToLoadWithError
  void onBannerAdLoadFailed(IronSourceError error);

  /// Android: onBannerAdClicked
  ///     iOS: didClickBanner
  void onBannerAdClicked();

  /// Android: onBannerAdScreenPresented
  ///     iOS: bannerWillPresentScreen
  void onBannerAdScreenPresented();

  /// Android: onBannerAdScreenDismissed
  ///     iOS: bannerDidDismissScreen
  void onBannerAdScreenDismissed();

  /// Android: onBannerAdLeftApplication
  ///     iOS: bannerWillLeaveApplication
  void onBannerAdLeftApplication();
}

abstract class IronSourceOfferwallListener {
  /// Android: onOfferwallAvailabilityChanged
  ///     iOS: offerwallHasChangedAvailability
  void onOfferwallAvailabilityChanged(bool isAvailable);

  /// Android: onOfferwallOpened
  ///     iOS: offerwallDidShow
  void onOfferwallOpened();

  /// Android: onOfferwallShowFailed
  ///     iOS: offerwallDidFailToShowWithError
  void onOfferwallShowFailed(IronSourceError error);

  /// Android: onOfferwallAdCredited
  ///     iOS: didReceiveOfferwallCredits
  void onOfferwallAdCredited(IronSourceOWCreditInfo creditInfo);

  /// Android: onGetOfferwallCreditsFailed
  ///     iOS: didFailToReceiveOfferwallCreditsWithError
  void onGetOfferwallCreditsFailed(IronSourceError error);

  /// Android: onOfferwallClosed
  ///     iOS: offerwallDidClose
  void onOfferwallClosed();
}

/// ARM Data ==================================================================

abstract class IronSourceImpressionDataListener {
  /// Android: onImpressionSuccess
  ///     iOS: impressionDataDidSucceed
  void onImpressionSuccess(IronSourceImpressionData? impressionData);
}

/// iOS 14 ====================================================================
///
abstract class IronSourceConsentViewListener {
  /// OS: consentViewDidLoadSuccess
  void consentViewDidLoadSuccess(String consentViewType);

  /// iOS: consentViewDidFailToLoadWithError
  void consentViewDidFailToLoad(IronSourceConsentViewError error);

  /// iOS: consentViewDidShowSuccess
  void consentViewDidShowSuccess(String consentViewType);

  /// iOS: consentViewDidFailToShowWithError
  void consentViewDidFailToShow(IronSourceConsentViewError error);

  /// iOS: consentViewDidAccept
  void consentViewDidAccept(String consentViewType);
}
