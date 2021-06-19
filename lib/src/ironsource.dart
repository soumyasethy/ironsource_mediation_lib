import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './ironsource_constants.dart';
import './ironsource_arg_parser.dart';
import './ironsource_rv_placement.dart';
import './ironsource_segment.dart';
import './ironsource_banner_size.dart';
import './ironsource_listeners.dart';

class IronSource {
  static const MethodChannel _channel = const MethodChannel(IronConst.METHOD_CHANNEL);

  /// Base API =================================================================

  /// Android: validateIntegration
  ///     iOS: validateIntegration
  static Future<void> validateIntegration() async {
    return _channel.invokeMethod('validateIntegration');
  }

  /// Android: shouldTrackNetworkState
  ///     iOS: shouldTrackReachability
  static Future<void> shouldTrackNetworkState(bool isEnabled) async {
    final args = IronSourceArgParser.shouldTrackNetworkState(isEnabled);
    return _channel.invokeMethod('shouldTrackNetworkState', args);
  }

  /// Android: setAdaptersDebug
  ///     iOS: setAdaptersDebug
  static Future<void> setAdaptersDebug(bool isEnabled) async {
    final args = IronSourceArgParser.setAdaptersDebug(isEnabled);
    return _channel.invokeMethod('setAdaptersDebug', args);
  }

  /// Android: setDynamicUserId
  ///     iOS: setDynamicUserId
  /// For RV server-to-server callback
  /// set before showRV
  static Future<void> setDynamicUserId(String dynamicUserId) async {
    final args = IronSourceArgParser.setDynamicUserId(dynamicUserId);
    return _channel.invokeMethod('setDynamicUserId', args);
  }

  /// Android: getAdvertiserId
  ///     iOS: advertiserId
  static Future<String> getAdvertiserId() async {
    final id = await _channel.invokeMethod<String>('getAdvertiserId');
    return id ?? "";
  }

  /// Android: setConsent
  ///     iOS: setConsent
  static Future<void> setConsent(bool isConsent) async {
    final args = IronSourceArgParser.setConsent(isConsent);
    return _channel.invokeMethod('setConsent', args);
  }

  /// Android: setSegment
  ///     iOS: setSegment
  static Future<void> setSegment(IronSourceSegment segment) async {
    final args = IronSourceArgParser.setSegment(segment);
    return _channel.invokeMethod('setSegment', args);
  }

  /// Android: setMetaData
  ///     iOS: setMetaDataWithKey
  static Future<void> setMetaData(Map<String, List<String>> metaData) async {
    final args = IronSourceArgParser.setMetaData(metaData);
    return _channel.invokeMethod('setMetaData', args);
  }

  /// SDK Init API =============================================================

  /// Android: setUserId
  ///     iOS: setUserId
  static Future<void> setUserId(String userId) async {
    final args = IronSourceArgParser.setUserId(userId);
    return _channel.invokeMethod('setUserId', args);
  }

  /// Android: init
  ///     iOS: initWithAppKey
  static Future<void> init({required String appKey, List<IronSourceAdUnit>? adUnits}) async {
    final args = IronSourceArgParser.init(appKey: appKey, adUnits: adUnits);
    return _channel.invokeMethod('init', args);
  }

  /// RV API ===================================================================

  /// Android: showRewardedVideo
  ///     iOS: showRewardedVideoWithViewController
  static Future<void> showRewardedVideo({String? placementName}) async {
    return _channel.invokeMethod(
        'showRewardedVideo', IronSourceArgParser.showRewardedVideo(placementName));
  }

  /// Android: getRewardedVideoPlacementInfo
  ///     iOS: rewardedVideoPlacementInfo
  static Future<IronSourceRVPlacement?> getRewardedVideoPlacementInfo(
      {required String placementName}) async {
    final args = IronSourceArgParser.getRewardedVideoPlacementInfo(placementName);
    final placementInfo = await _channel.invokeMethod('getRewardedVideoPlacementInfo', args);
    return placementInfo != null ? ParserUtil.getRVPlacementFromArguments(placementInfo) : null;
  }

  /// Android: isRewardedVideoAvailable
  ///     iOS: hasRewardedVideo
  static Future<bool> isRewardedVideoAvailable() async {
    final bool isAvailable = await _channel.invokeMethod('isRewardedVideoAvailable');
    return isAvailable;
  }

  /// Android: isRewardedVideoPlacementCapped
  ///     iOS: isRewardedVideoCappedForPlacement
  static Future<bool> isRewardedVideoPlacementCapped({required String placementName}) async {
    final args = IronSourceArgParser.isRewardedVideoPlacementCapped(placementName);
    final bool isCapped = await _channel.invokeMethod('isRewardedVideoPlacementCapped', args);
    return isCapped;
  }

  /// Android: setRewardedVideoServerParameters
  ///     iOS: setRewardedVideoServerParameters
  static Future<void> setRewardedVideoServerParams(Map<String, String> parameters) async {
    final args = IronSourceArgParser.setRewardedVideoServerParams(parameters);
    return _channel.invokeMethod('setRewardedVideoServerParams', args);
  }

  /// Android: clearRewardedVideoServerParameters
  ///     iOS: clearRewardedVideoServerParameters
  static Future<void> clearRewardedVideoServerParams() async {
    return _channel.invokeMethod('clearRewardedVideoServerParams');
  }

  /// IS API ===================================================================

  /// Android: loadInterstitial
  ///     iOS: loadInterstitial
  static Future<void> loadInterstitial() async {
    return _channel.invokeMethod('loadInterstitial');
  }

  /// Android: showInterstitial
  ///     iOS: showInterstitialWithViewController
  static Future<void> showInterstitial({String? placementName}) async {
    final args = IronSourceArgParser.showInterstitial(placementName);
    return _channel.invokeMethod('showInterstitial', args);
  }

  /// Android: isInterstitialReady
  ///     iOS: hasInterstitial
  static Future<bool> isInterstitialReady() async {
    final bool isISReady = await _channel.invokeMethod('isInterstitialReady');
    return isISReady;
  }

  /// Android: isInterstitialPlacementCapped
  ///     iOS: isInterstitialCappedForPlacement
  static Future<bool> isInterstitialPlacementCapped({required String placementName}) async {
    final args = IronSourceArgParser.isInterstitialPlacementCapped(placementName);
    final bool isCapped = await _channel.invokeMethod('isInterstitialPlacementCapped', args);
    return isCapped;
  }

  /// BN API ===================================================================

  /// Android: loadBanner
  ///     iOS: loadBannerWithViewController
  /// @param verticalOffset - Upward < 0 < Downward. Android:dp, iOS:point
  static Future<void> loadBanner({
    required IronSourceBannerSize size,
    required IronSourceBannerPosition position,
    int? verticalOffset,
    String? placementName,
  }) async {
    final args = IronSourceArgParser.loadBanner(size, position,
        offset: verticalOffset, placementName: placementName);
    return _channel.invokeMethod('loadBanner', args);
  }

  /// Android: destroyBanner
  ///     iOS: destroyBanner
  static Future<void> destroyBanner() async {
    return _channel.invokeMethod('destroyBanner');
  }

  /// Android:
  ///     iOS:
  static Future<void> displayBanner() async {
    return _channel.invokeMethod('displayBanner');
  }

  /// Android:
  ///     iOS:
  /// This simply change the visibility of the banner view.
  /// Reloading takes place even while it's hidden.
  /// Thus, not recommended unless it's for momentary use.
  static Future<void> hideBanner() async {
    return _channel.invokeMethod('hideBanner');
  }

  /// Android: isBannerPlacementCapped
  ///     iOS: isBannerCappedForPlacement
  static Future<bool> isBannerPlacementCapped(String placementName) async {
    final args = IronSourceArgParser.isBannerPlacementCapped(placementName);
    final bool isCapped = await _channel.invokeMethod('isBannerPlacementCapped', args);
    return isCapped;
  }

  /// OW API ===================================================================

  /// Android: showOfferwall
  ///     iOS: showOfferwallWithViewController
  static Future<void> showOfferwall({String? placementName}) async {
    final args = IronSourceArgParser.showOfferwall(placementName);
    return _channel.invokeMethod('showOfferwall', args);
  }

  /// Android: getOfferwallCredits
  ///     iOS: offerwallCredits
  /// credit info will be notified through the OW listener
  static Future<void> getOfferwallCredits() async {
    return _channel.invokeMethod('getOfferwallCredits');
  }

  /// Android: isOfferwallAvailable
  ///     iOS: hasOfferwall
  static Future<bool> isOfferwallAvailable() async {
    final bool isAvailable = await _channel.invokeMethod('isOfferwallAvailable');
    return isAvailable;
  }

  /// OW Config API ===========================================================
  
  /// This must be called before init
  /// OW client side automatic result polling
  /// Android: setClientSideCallbacks
  ///     iOS: setUseClientSideCallbacks
  static Future<void> setClientSideCallbacks(bool isEnabled) async {
    final args = IronSourceArgParser.setClientSideCallbacks(isEnabled);
    return _channel.invokeMethod('setClientSideCallbacks', args);
  }

  /// This must be called before init
  /// Android: setOfferwallCustomParams
  ///     iOS: setOfferwallCustomParameters
  static Future<void> setOfferwallCustomParams(Map<String, String> parameters) async {
    final args = IronSourceArgParser.setOfferwallCustomParams(parameters);
    return _channel.invokeMethod('setOfferwallCustomParams', args);
  }

  /// iOS ConversionValue API ==================================================
  ///     iOS: getConversionValue
  static Future<int?> getConversionValue() async {
    if (!Platform.isIOS) {
      return null;
    }
    final int? conversionValue = await _channel.invokeMethod('getConversionValue');
    return conversionValue;
  }

  /// iOS ConsentView API ==================================================
  ///     iOS: loadConsentViewWithType
  static Future<void> loadConsentViewWithType(String consentViewType) async {
    if (!Platform.isIOS) {
      return;
    }
    final args = IronSourceArgParser.loadConsentViewWithType(consentViewType);
    return _channel.invokeMethod('loadConsentViewWithType', args);
  }

  ///     iOS: showConsentViewWithViewController
  static Future<void> showConsentViewWithType(String consentViewType) async {
    if (!Platform.isIOS) {
      return;
    }
    final args = IronSourceArgParser.showConsentViewWithType(consentViewType);
    return _channel.invokeMethod('showConsentViewWithType', args);
  }

  /// Listeners and MethodCall handling ========================================

  static IronSourceRewardedVideoListener? _rewardedVideoListener;
  static IronSourceInterstitialListener? _interstitialListener;
  static IronSourceBannerListener? _bannerListener;
  static IronSourceOfferwallListener? _offerwallListener;
  static IronSourceImpressionDataListener? _impressionDataListener;
  static IronSourceConsentViewListener? _consentViewListener;

  static void setListeners(
      {IronSourceRewardedVideoListener? rewardedVideoListener,
      IronSourceInterstitialListener? interstitialListener,
      IronSourceBannerListener? bannerListener,
      IronSourceOfferwallListener? offerwallListener,
      IronSourceImpressionDataListener? impressionDataListener,
      IronSourceConsentViewListener? consentViewListener}) {
    _rewardedVideoListener = rewardedVideoListener;
    _interstitialListener = interstitialListener;
    _bannerListener = bannerListener;
    _offerwallListener = offerwallListener;
    _impressionDataListener = impressionDataListener;
    _consentViewListener = consentViewListener;
    _channel.setMethodCallHandler(handleMethodCall);
  }

  static void setRVListener(IronSourceRewardedVideoListener? rewardedVideoListener) {
    _rewardedVideoListener = rewardedVideoListener;
    _channel.setMethodCallHandler(handleMethodCall);
  }

  static void setISListener(IronSourceInterstitialListener? interstitialListener) {
    _interstitialListener = interstitialListener;
    _channel.setMethodCallHandler(handleMethodCall);
  }

  static void setBNListener(IronSourceBannerListener? bannerListener) {
    _bannerListener = bannerListener;
    _channel.setMethodCallHandler(handleMethodCall);
  }

  static void setOWListener(IronSourceOfferwallListener? offerwallListener) {
    _offerwallListener = offerwallListener;
    _channel.setMethodCallHandler(handleMethodCall);
  }

  static void setImpressionDataListener(IronSourceImpressionDataListener? impressionDataListener) {
    _impressionDataListener = impressionDataListener;
    _channel.setMethodCallHandler(handleMethodCall);
  }

  @visibleForTesting
  static Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      // RV events
      case 'onRewardedVideoAdOpened':
        return _rewardedVideoListener?.onRewardedVideoAdOpened();
      case 'onRewardedVideoAdClosed':
        return _rewardedVideoListener?.onRewardedVideoAdClosed();
      case 'onRewardedVideoAvailabilityChanged':
        return _rewardedVideoListener?.onRewardedVideoAvailabilityChanged(
            IronSourceArgParser.onRewardedVideoAvailabilityChanged(call.arguments));
      case 'onRewardedVideoAdRewarded':
        return _rewardedVideoListener?.onRewardedVideoAdRewarded(
            IronSourceArgParser.onRewardedVideoAdRewarded(call.arguments));
      case 'onRewardedVideoAdShowFailed':
        return _rewardedVideoListener?.onRewardedVideoAdShowFailed(
            IronSourceArgParser.onRewardedVideoAdShowFailed(call.arguments));
      case 'onRewardedVideoAdClicked':
        return _rewardedVideoListener?.onRewardedVideoAdClicked(
            IronSourceArgParser.onRewardedVideoAdClicked(call.arguments));
      case 'onRewardedVideoAdStarted':
        return _rewardedVideoListener?.onRewardedVideoAdStarted();
      case 'onRewardedVideoAdEnded':
        return _rewardedVideoListener?.onRewardedVideoAdEnded();
      // IS Events
      case 'onInterstitialAdReady':
        return _interstitialListener?.onInterstitialAdReady();
      case 'onInterstitialAdLoadFailed':
        return _interstitialListener?.onInterstitialAdLoadFailed(
            IronSourceArgParser.onInterstitialAdLoadFailed(call.arguments));
      case 'onInterstitialAdOpened':
        return _interstitialListener?.onInterstitialAdOpened();
      case 'onInterstitialAdClosed':
        return _interstitialListener?.onInterstitialAdClosed();
      case 'onInterstitialAdShowSucceeded':
        return _interstitialListener?.onInterstitialAdShowSucceeded();
      case 'onInterstitialAdShowFailed':
        return _interstitialListener?.onInterstitialAdShowFailed(
            IronSourceArgParser.onInterstitialAdShowFailed(call.arguments));
      case 'onInterstitialAdClicked':
        return _interstitialListener?.onInterstitialAdClicked();
      // BN Events
      case 'onBannerAdLoaded':
        return _bannerListener?.onBannerAdLoaded();
      case 'onBannerAdLoadFailed':
        return _bannerListener
            ?.onBannerAdLoadFailed(IronSourceArgParser.onBannerAdLoadFailed(call.arguments));
      case 'onBannerAdClicked':
        return _bannerListener?.onBannerAdClicked();
      case 'onBannerAdScreenPresented':
        return _bannerListener?.onBannerAdScreenPresented();
      case 'onBannerAdScreenDismissed':
        return _bannerListener?.onBannerAdScreenDismissed();
      case 'onBannerAdLeftApplication':
        return _bannerListener?.onBannerAdLeftApplication();
      // OW Events
      case 'onOfferwallAvailabilityChanged':
        return _offerwallListener?.onOfferwallAvailabilityChanged(
            IronSourceArgParser.onOfferwallAvailabilityChanged(call.arguments));
      case 'onOfferwallOpened':
        return _offerwallListener?.onOfferwallOpened();
      case 'onOfferwallShowFailed':
        return _offerwallListener
            ?.onOfferwallShowFailed(IronSourceArgParser.onOfferwallShowFailed(call.arguments));
      case 'onOfferwallAdCredited':
        return _offerwallListener
            ?.onOfferwallAdCredited(IronSourceArgParser.onOfferwallAdCredited(call.arguments));
      case 'onGetOfferwallCreditsFailed':
        return _offerwallListener?.onGetOfferwallCreditsFailed(
            IronSourceArgParser.onGetOfferwallCreditsFailed(call.arguments));
      case 'onOfferwallClosed':
        return _offerwallListener?.onOfferwallClosed();
      // ImpressionData Event
      case 'onImpressionSuccess':
        return _impressionDataListener
            ?.onImpressionSuccess(IronSourceArgParser.onImpressionSuccess(call.arguments));
      // iOS14 ConsentView Event
      case 'consentViewDidLoadSuccess':
        return _consentViewListener?.consentViewDidLoadSuccess(
            IronSourceArgParser.consentViewDidLoadSuccess(call.arguments));
      case 'consentViewDidFailToLoad':
        return _consentViewListener?.consentViewDidFailToLoad(
            IronSourceArgParser.consentViewDidFailToLoad(call.arguments));
      case 'consentViewDidShowSuccess':
        return _consentViewListener?.consentViewDidShowSuccess(
            IronSourceArgParser.consentViewDidShowSuccess(call.arguments));
      case 'consentViewDidFailToShow':
        return _consentViewListener?.consentViewDidFailToShow(
            IronSourceArgParser.consentViewDidFailToShow(call.arguments));
      case 'consentViewDidAccept':
        return _consentViewListener
            ?.consentViewDidAccept(IronSourceArgParser.consentViewDidAccept(call.arguments));
      default:
        throw UnimplementedError("Method not implemented: ${call.method}");
    }
  }
}

/// enums ======================================================================

enum IronSourceAdUnit {
  RewardedVideo,
  Interstitial,
  Offerwall,
  Banner,
}

extension ParseToString on IronSourceAdUnit {
  String parse() {
    switch (this) {
      case IronSourceAdUnit.RewardedVideo:
        return "REWARDED_VIDEO";
      case IronSourceAdUnit.Interstitial:
        return "INTERSTITIAL";
      case IronSourceAdUnit.Offerwall:
        return "OFFERWALL";
      case IronSourceAdUnit.Banner:
        return "BANNER";
    }
  }
}

enum IronSourceBannerPosition {
  Top,
  Center,
  Bottom,
}

extension ParseToInt on IronSourceBannerPosition {
  int toInt() {
    switch (this) {
      case IronSourceBannerPosition.Top:
        return 0;
      case IronSourceBannerPosition.Center:
        return 1;
      case IronSourceBannerPosition.Bottom:
        return 2;
    }
  }
}
