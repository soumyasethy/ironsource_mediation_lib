import './ironsource_constants.dart';
import './ironsource_error.dart';
import './ironsource.dart';
import './ironsource_rv_placement.dart';
import './ironsource_segment.dart';
import './ironsource_banner_size.dart';
import './ironsource_ow_credit_info.dart';
import './ironsource_impression_data.dart';

typedef T ValueGetter<O, T>(O obj);

/// Handles argument parsing for MethodChannel calls
class IronSourceArgParser {
  /// Base API ================================================================

  /// returns
  ///   { isEnabled: bool };
  static Map<String, dynamic> shouldTrackNetworkState(bool isEnabled) {
    return {IronConst.IS_ENABLED: isEnabled};
  }

  /// returns
  ///   { isEnabled: bool };
  static Map<String, dynamic> setAdaptersDebug(bool isEnabled) {
    return {IronConst.IS_ENABLED: isEnabled};
  }

  /// returns
  ///   { userId: String }
  static Map<String, dynamic> setDynamicUserId(String dynamicUserId) {
    return {IronConst.USER_ID: dynamicUserId};
  }

  /// returns
  ///   { isConsent: bool };
  static Map<String, dynamic> setConsent(bool isConsent) {
    return {IronConst.IS_CONSENT: isConsent};
  }

  /// returns
  ///   { segment: Map<String, dynamic> };
  static Map<String, dynamic> setSegment(IronSourceSegment segment) {
    return {IronConst.SEGMENT: segment.toMap()};
  }

  /// returns
  ///   { metaData: Map<String, List<String>> };
  static Map<String, dynamic> setMetaData(Map<String, List<String>> metaData) {
    return {IronConst.META_DATA: metaData};
  }

  /// Init API ================================================================

  /// returns
  ///   { appKey: String, adUnits: List<String>? }
  static Map<String, dynamic> init({required String appKey, List<IronSourceAdUnit>? adUnits}) {
    final Map<String, dynamic> args = {IronConst.APP_KEY: appKey};
    if (adUnits != null && adUnits.length > 0) {
      args[IronConst.AD_UNITS] = adUnits.map((unit) => unit.parse()).toList();
    }
    return args;
  }

  /// returns
  ///   { userId: String }
  static Map<String, dynamic> setUserId(String userId) {
    return {IronConst.USER_ID: userId};
  }

  /// RV API ==================================================================

  /// returns
  ///   { placementName: String? };
  static Map<String, dynamic> showRewardedVideo(String? placementName) {
    return placementName != null ? {IronConst.PLACEMENT_NAME: placementName} : {};
  }

  /// returns
  ///   { placementName: String };
  static Map<String, dynamic> getRewardedVideoPlacementInfo(String placementName) {
    return {IronConst.PLACEMENT_NAME: placementName};
  }

  /// returns
  ///   { placementName: String };
  static Map<String, dynamic> isRewardedVideoPlacementCapped(String placementName) {
    return {IronConst.PLACEMENT_NAME: placementName};
  }

  /// returns
  ///   { parameters: Map<String, String> };
  static Map<String, dynamic> setRewardedVideoServerParams(Map<String, String> parameters) {
    return {IronConst.PARAMETERS: parameters};
  }

  /// IS API ==================================================================

  /// returns
  ///   { placementName: String? };
  static Map<String, dynamic> showInterstitial(String? placementName) {
    return placementName != null ? {IronConst.PLACEMENT_NAME: placementName} : {};
  }

  /// returns
  ///   { placementName: String };
  static Map<String, dynamic> isInterstitialPlacementCapped(String placementName) {
    return {IronConst.PLACEMENT_NAME: placementName};
  }

  /// BN API ==================================================================

  /// returns
  ///   {
  ///     description: String,
  ///     width: int,
  ///     height: int,
  ///     position: int,
  ///     offset: int?
  ///     placementName: String?
  ///   };
  static Map<String, dynamic> loadBanner(
      IronSourceBannerSize size, IronSourceBannerPosition position,
      {int? offset, String? placementName}) {
    final params = {
      IronConst.DESCRIPTION: size.description,
      IronConst.WIDTH: size.width,
      IronConst.HEIGHT: size.height,
      IronConst.POSITION: position.toInt(),
    };
    if (offset != null) params[IronConst.OFFSET] = offset;
    if (placementName != null) params[IronConst.PLACEMENT_NAME] = placementName;
    return params;
  }

  /// returns
  ///   { placementName: String };
  static Map<String, dynamic> isBannerPlacementCapped(String placementName) {
    return {IronConst.PLACEMENT_NAME: placementName};
  }

  /// OW ======================================================================

  /// returns
  ///   { placementName: String? }
  static Map<String, dynamic> showOfferwall(String? placementName) {
    return placementName != null ? {IronConst.PLACEMENT_NAME: placementName} : {};
  }

  /// iOS14 ConsentView =======================================================
  static Map<String, dynamic> loadConsentViewWithType(String consentViewType) {
    return {IronConst.CONSENT_VIEW_TYPE: consentViewType};
  }

  static Map<String, dynamic> showConsentViewWithType(String consentViewType) {
    return {IronConst.CONSENT_VIEW_TYPE: consentViewType};
  }

  /// Listener callbacks ======================================================

  /// RV ======================================================================

  static bool onRewardedVideoAvailabilityChanged(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey(IronConst.IS_AVAILABLE, arguments);
  }

  static IronSourceRVPlacement onRewardedVideoAdRewarded(dynamic arguments) {
    return ParserUtil.getRVPlacementFromArguments(arguments);
  }

  static IronSourceError onRewardedVideoAdShowFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  static IronSourceRVPlacement onRewardedVideoAdClicked(dynamic arguments) {
    return ParserUtil.getRVPlacementFromArguments(arguments);
  }

  /// IS ======================================================================

  static IronSourceError onInterstitialAdLoadFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  static IronSourceError onInterstitialAdShowFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /// BN =======================================================================

  static IronSourceError onBannerAdLoadFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /// OW ======================================================================

  static bool onOfferwallAvailabilityChanged(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey(IronConst.IS_AVAILABLE, arguments);
  }

  static IronSourceOWCreditInfo onOfferwallAdCredited(dynamic arguments) {
    final credits = ParserUtil.getArgumentValueWithKey<int>(IronConst.CREDITS, arguments);
    final totalCredits =
        ParserUtil.getArgumentValueWithKey<int>(IronConst.TOTAL_CREDITS, arguments);
    final totalCreditsFlag =
        ParserUtil.getArgumentValueWithKey<bool>(IronConst.TOTAL_CREDITS_FLAG, arguments);
    return IronSourceOWCreditInfo(
        credits: credits, totalCredits: totalCredits, totalCreditsFlag: totalCreditsFlag);
  }

  static IronSourceError onOfferwallShowFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  static IronSourceError onGetOfferwallCreditsFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /// Impression Data =============================================================
  static IronSourceImpressionData? onImpressionSuccess(dynamic arguments) {
    if (arguments == null) {
      return null;
    }
    final String? auctionId =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.AUCTION_ID, arguments);
    final String? adUnit =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.AD_UNIT, arguments);
    final String? country =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.COUNTRY, arguments);
    final String? ab = ParserUtil.getArgumentValueWithKey<String?>(IronConst.AB, arguments);
    final String? segmentName =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.SEGMENT_NAME, arguments);
    final String? placement =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.PLACEMENT, arguments);
    final String? adNetwork =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.AD_NETWORK, arguments);
    final String? instanceName =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.INSTANCE_NAME, arguments);
    final String? instanceId =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.INSTANCE_ID, arguments);
    final double? revenue =
        ParserUtil.getArgumentValueWithKey<double?>(IronConst.REVENUE, arguments);
    final String? precision =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.PRECISION, arguments);
    final double? lifetimeRevenue =
        ParserUtil.getArgumentValueWithKey<double?>(IronConst.LIFETIME_REVENUE, arguments);
    final String? encryptedCPM =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.ENCRYPTED_CPM, arguments);
    return IronSourceImpressionData(
      auctionId: auctionId,
      adUnit: adUnit,
      country: country,
      ab: ab,
      segmentName: segmentName,
      placement: placement,
      adNetwork: adNetwork,
      instanceName: instanceName,
      instanceId: instanceId,
      revenue: revenue,
      precision: precision,
      lifetimeRevenue: lifetimeRevenue,
      encryptedCPM: encryptedCPM,
    );
  }

  /// iOS14 ConsentView ===========================================================

  static String consentViewDidLoadSuccess(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey<String?>(IronConst.CONSENT_VIEW_TYPE, arguments) ??
        "";
  }

  static IronSourceConsentViewError consentViewDidFailToLoad(dynamic arguments) {
    final error = ParserUtil.getIronSourceErrorFromArguments(arguments);
    final consentViewType =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.CONSENT_VIEW_TYPE, arguments) ?? "";
    return IronSourceConsentViewError(
        errorCode: error.errorCode, message: error.message, consentViewType: consentViewType);
  }

  static String consentViewDidShowSuccess(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey<String?>(IronConst.CONSENT_VIEW_TYPE, arguments) ??
        "";
  }

  static IronSourceConsentViewError consentViewDidFailToShow(dynamic arguments) {
    final error = ParserUtil.getIronSourceErrorFromArguments(arguments);
    final consentViewType =
        ParserUtil.getArgumentValueWithKey<String?>(IronConst.CONSENT_VIEW_TYPE, arguments) ?? "";
    return IronSourceConsentViewError(
        errorCode: error.errorCode, message: error.message, consentViewType: consentViewType);
  }

  static String consentViewDidAccept(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey<String?>(IronConst.CONSENT_VIEW_TYPE, arguments) ??
        "";
  }

  /// Config API ==================================================================

  ///   /// returns
  ///   { isEnabled: bool };
  static Map<String, dynamic> setClientSideCallbacks(bool isEnabled) {
    return {IronConst.IS_ENABLED: isEnabled};
  }

  /// returns
  ///   { parameters: Map<String, String> };
  static Map<String, dynamic> setOfferwallCustomParams(Map<String, String> parameters) {
    return {IronConst.PARAMETERS: parameters};
  }
}

/// Util wrapper class
class ParserUtil {
  /// arguments Map value retriever
  static T getArgumentValueWithKey<T>(String key, dynamic arguments) {
    if (arguments == null) {
      throw ArgumentError('arguments is null');
    }
    if (!isNullable<T>() && arguments[key] == null) {
      throw ArgumentError('key: $key does not exist');
    }
    if (arguments[key] is! T) {
      throw ArgumentError('Value retrieved is not a type of ${T.toString()}');
    }
    return arguments[key] as T;
  }

  static bool isNullable<T>() => null is T;

  static T? nullOrValue<O, T>(O? obj, ValueGetter<O, T> f) => obj != null ? f(obj) : null;

  /// throws if arguments is null
  static IronSourceRVPlacement getRVPlacementFromArguments(dynamic arguments) {
    final placementName = getArgumentValueWithKey<String>(IronConst.PLACEMENT_NAME, arguments);
    final rewardName = getArgumentValueWithKey<String>(IronConst.REWARD_NAME, arguments);
    final rewardAmount = getArgumentValueWithKey<int>(IronConst.REWARD_AMOUNT, arguments);
    return IronSourceRVPlacement(
        placementName: placementName, rewardName: rewardName, rewardAmount: rewardAmount);
  }

  /// null safe for arguments
  static IronSourceError getIronSourceErrorFromArguments(dynamic arguments) {
    final errorCode = nullOrValue(
        arguments, (args) => ParserUtil.getArgumentValueWithKey<int?>(IronConst.ERROR_CODE, args));
    final message = nullOrValue(arguments,
        (args) => ParserUtil.getArgumentValueWithKey<String?>(IronConst.MESSAGE, arguments));
    return IronSourceError(errorCode: errorCode, message: message);
  }
}
