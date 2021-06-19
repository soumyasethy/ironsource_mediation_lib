import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironsource_mediation/src/ironsource_impression_data.dart';
import 'package:ironsource_mediation/src/ironsource_ow_credit_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/src/mock.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:ironsource_mediation/src/ironsource_constants.dart';
import './ironsource_listener_test.mocks.dart';

/// Test a method string triggers matching listener function
///
@GenerateMocks([
  IronSourceRewardedVideoListener,
  IronSourceInterstitialListener,
  IronSourceBannerListener,
  IronSourceOfferwallListener,
  IronSourceImpressionDataListener,
  IronSourceConsentViewListener
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockIronSourceRewardedVideoListener mockRVListener;
  late MockIronSourceInterstitialListener mockISListener;
  late MockIronSourceBannerListener mockBNListener;
  late MockIronSourceOfferwallListener mockOWListener;
  late MockIronSourceImpressionDataListener mockImpDataListener;
  late MockIronSourceConsentViewListener mockConsentViewListener;

  setUp(() {
    mockRVListener = MockIronSourceRewardedVideoListener();
    mockISListener = MockIronSourceInterstitialListener();
    mockBNListener = MockIronSourceBannerListener();
    mockOWListener = MockIronSourceOfferwallListener();
    mockImpDataListener = MockIronSourceImpressionDataListener();
    mockConsentViewListener = MockIronSourceConsentViewListener();
    IronSource.setListeners(
        rewardedVideoListener: mockRVListener,
        interstitialListener: mockISListener,
        bannerListener: mockBNListener,
        offerwallListener: mockOWListener,
        impressionDataListener: mockImpDataListener,
        consentViewListener: mockConsentViewListener);
  });

  group('RVListener', () {
    group('onRewardedVideoAdOpened', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onRewardedVideoAdOpened'));
        verify(mockRVListener.onRewardedVideoAdOpened()).called(1);
      });
    });
    group('onRewardedVideoAdClosed', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onRewardedVideoAdClosed'));
        verify(mockRVListener.onRewardedVideoAdClosed()).called(1);
      });
    });
    group('onRewardedVideoAvailabilityChanged', () {
      test('should trigger the corresponding callback with the argument', () async {
        await IronSource.handleMethodCall(
            MethodCall('onRewardedVideoAvailabilityChanged', {IronConst.IS_AVAILABLE: true}));
        verify(mockRVListener.onRewardedVideoAvailabilityChanged(true)).called(1);
      });
    });
    group('onRewardedVideoAdRewarded', () {
      test('should trigger the corresponding callback with the argument RVPlacement', () async {
        final placementName = "Default";
        final rewardName = "Virtual Item";
        final rewardAmount = 1;
        await IronSource.handleMethodCall(MethodCall('onRewardedVideoAdRewarded', {
          IronConst.PLACEMENT_NAME: placementName,
          IronConst.REWARD_NAME: rewardName,
          IronConst.REWARD_AMOUNT: rewardAmount
        }));
        final expected = IronSourceRVPlacement(
            placementName: placementName, rewardName: rewardName, rewardAmount: rewardAmount);
        verify(mockRVListener.onRewardedVideoAdRewarded(expected)).called(1);
      });
    });
    group('onRewardedVideoAdShowFailed', () {
      test('should trigger the corresponding callback with the argument IronSourceError', () async {
        final errorCode = 508;
        final message = "No fill";
        await IronSource.handleMethodCall(MethodCall('onRewardedVideoAdShowFailed', {
          IronConst.ERROR_CODE: errorCode,
          IronConst.MESSAGE: message,
        }));
        final expected = IronSourceError(errorCode: errorCode, message: message);
        verify(mockRVListener.onRewardedVideoAdShowFailed(expected)).called(1);
      });
    });
    group('onRewardedVideoAdClicked', () {
      test('should trigger the corresponding callback with the argument RVPlacement', () async {
        final placementName = "Default";
        final rewardName = "Virtual Item";
        final rewardAmount = 1;
        await IronSource.handleMethodCall(MethodCall('onRewardedVideoAdClicked', {
          IronConst.PLACEMENT_NAME: placementName,
          IronConst.REWARD_NAME: rewardName,
          IronConst.REWARD_AMOUNT: rewardAmount
        }));
        final expected = IronSourceRVPlacement(
            placementName: placementName, rewardName: rewardName, rewardAmount: rewardAmount);
        verify(mockRVListener.onRewardedVideoAdClicked(expected)).called(1);
      });
    });
    group('onRewardedVideoAdStarted', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onRewardedVideoAdStarted'));
        verify(mockRVListener.onRewardedVideoAdStarted()).called(1);
      });
    });
    group('onRewardedVideoAdEnded', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onRewardedVideoAdEnded'));
        verify(mockRVListener.onRewardedVideoAdEnded()).called(1);
      });
    });
  });

  group('ISListener', () {
    group('onInterstitialAdReady', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onInterstitialAdReady'));
        verify(mockISListener.onInterstitialAdReady()).called(1);
      });
    });
    group('onInterstitialAdLoadFailed', () {
      test('should trigger the corresponding callback', () async {
        final errorCode = 510;
        final message = "Server response failed";
        await IronSource.handleMethodCall(MethodCall('onInterstitialAdLoadFailed', {
          IronConst.ERROR_CODE: errorCode,
          IronConst.MESSAGE: message,
        }));
        final expected = IronSourceError(errorCode: errorCode, message: message);
        verify(mockISListener.onInterstitialAdLoadFailed(expected)).called(1);
      });
    });
    group('onInterstitialAdOpened', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onInterstitialAdOpened'));
        verify(mockISListener.onInterstitialAdOpened()).called(1);
      });
    });
    group('onInterstitialAdClosed', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onInterstitialAdClosed'));
        verify(mockISListener.onInterstitialAdClosed()).called(1);
      });
    });
    group('onInterstitialAdShowSucceeded', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onInterstitialAdShowSucceeded'));
        verify(mockISListener.onInterstitialAdShowSucceeded()).called(1);
      });
    });
    group('onInterstitialAdShowFailed', () {
      test('should trigger the corresponding callback with the argument IronSourceError', () async {
        final errorCode = 520;
        final message = "No internet connection";
        await IronSource.handleMethodCall(MethodCall('onInterstitialAdShowFailed', {
          IronConst.ERROR_CODE: errorCode,
          IronConst.MESSAGE: message,
        }));
        final expected = IronSourceError(errorCode: errorCode, message: message);
        verify(mockISListener.onInterstitialAdShowFailed(expected)).called(1);
      });
    });
    group('onInterstitialAdClicked', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onInterstitialAdClicked'));
        verify(mockISListener.onInterstitialAdClicked()).called(1);
      });
    });
  });

  group('BNListener', () {
    group('onBannerAdLoaded', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onBannerAdLoaded'));
        verify(mockBNListener.onBannerAdLoaded()).called(1);
      });
    });
    group('onBannerAdLoadFailed', () {
      test('should trigger the corresponding callback', () async {
        final errorCode = 606;
        final message = "Error";
        await IronSource.handleMethodCall(MethodCall('onBannerAdLoadFailed', {
          IronConst.ERROR_CODE: errorCode,
          IronConst.MESSAGE: message,
        }));
        final expected = IronSourceError(errorCode: errorCode, message: message);
        verify(mockBNListener.onBannerAdLoadFailed(expected)).called(1);
      });
    });
    group('onBannerAdClicked', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onBannerAdClicked'));
        verify(mockBNListener.onBannerAdClicked()).called(1);
      });
    });
    group('onBannerAdScreenPresented', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onBannerAdScreenPresented'));
        verify(mockBNListener.onBannerAdScreenPresented()).called(1);
      });
    });
    group('onBannerAdScreenDismissed', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onBannerAdScreenDismissed'));
        verify(mockBNListener.onBannerAdScreenDismissed()).called(1);
      });
    });
    group('onBannerAdLeftApplication', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onBannerAdLeftApplication'));
        verify(mockBNListener.onBannerAdLeftApplication()).called(1);
      });
    });
  });

  group('OWListener', () {
    group('onOfferwallAvailabilityChanged', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(
            MethodCall('onOfferwallAvailabilityChanged', {IronConst.IS_AVAILABLE: true}));
        verify(mockOWListener.onOfferwallAvailabilityChanged(true)).called(1);
      });
    });
    group('onOfferwallOpened', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onOfferwallOpened'));
        verify(mockOWListener.onOfferwallOpened()).called(1);
      });
    });
    group('onOfferwallShowFailed', () {
      test('should trigger the corresponding callback', () async {
        final errorCode = 520;
        final message = "No Internet";
        await IronSource.handleMethodCall(MethodCall('onOfferwallShowFailed', {
          IronConst.ERROR_CODE: errorCode,
          IronConst.MESSAGE: message,
        }));
        final expected = IronSourceError(errorCode: errorCode, message: message);
        verify(mockOWListener.onOfferwallShowFailed(expected)).called(1);
      });
    });
    group('onOfferwallAdCredited', () {
      test('should trigger the corresponding callback', () async {
        final credits = 10;
        final totalCredits = 100;
        final totalCreditsFlag = false;
        await IronSource.handleMethodCall(MethodCall('onOfferwallAdCredited', {
          IronConst.CREDITS: credits,
          IronConst.TOTAL_CREDITS: totalCredits,
          IronConst.TOTAL_CREDITS_FLAG: totalCreditsFlag,
        }));
        final expected = IronSourceOWCreditInfo(
            credits: credits, totalCredits: totalCredits, totalCreditsFlag: totalCreditsFlag);
        verify(mockOWListener.onOfferwallAdCredited(expected)).called(1);
      });
    });
    group('onGetOfferwallCreditsFailed', () {
      test('should trigger the corresponding callback', () async {
        final errorCode = 0;
        final message = "Something happened";
        await IronSource.handleMethodCall(MethodCall('onGetOfferwallCreditsFailed', {
          IronConst.ERROR_CODE: errorCode,
          IronConst.MESSAGE: message,
        }));
        final expected = IronSourceError(errorCode: errorCode, message: message);
        verify(mockOWListener.onGetOfferwallCreditsFailed(expected)).called(1);
      });
    });
    group('onOfferwallClosed', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onOfferwallClosed'));
        verify(mockOWListener.onOfferwallClosed()).called(1);
      });
    });
  });

  group('ImpressionDataListener', () {
    group('onImpressionSuccess with null arguments', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(MethodCall('onImpressionSuccess', null));
        verify(mockImpDataListener.onImpressionSuccess(null)).called(1);
      });
    });
    group('onImpressionSuccess with imp data argument', () {
      test('should trigger the corresponding callback', () async {
        final arguments = {
          'auctionId': 'some-auction-id-1234',
          'adUnit': 'RewardedVideo',
          'country': 'JP',
          'ab': 'a',
          'segmentName': 'DemoSegment',
          'placement': 'DefaultPlacement',
          'adNetwork': 'ironSource',
          'instanceName': 'DefaultInstance',
          'instanceId': 'abcd1234',
          'revenue': 0.1,
          'precision': 'CPM',
          'lifetimeRevenue': 1.0,
          'encryptedCPM': 'encryptedForFAN123',
        };
        final expected = IronSourceImpressionData(
          auctionId: 'some-auction-id-1234',
          adUnit: 'RewardedVideo',
          country: 'JP',
          ab: 'a',
          segmentName: 'DemoSegment',
          placement: 'DefaultPlacement',
          adNetwork: 'ironSource',
          instanceName: 'DefaultInstance',
          instanceId: 'abcd1234',
          revenue: 0.1,
          precision: 'CPM',
          lifetimeRevenue: 1.0,
          encryptedCPM: 'encryptedForFAN123',
        );
        await IronSource.handleMethodCall(MethodCall('onImpressionSuccess', arguments));
        verify(mockImpDataListener.onImpressionSuccess(expected)).called(1);
      });
    });
  });

  group('ConsentViewListener', () {
    group('consentViewDidLoadSuccess', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(
            MethodCall('consentViewDidLoadSuccess', {'consentViewType': 'pre'}));
        verify(mockConsentViewListener.consentViewDidLoadSuccess('pre')).called(1);
      });
    });
    group('consentViewDidFailToLoad', () {
      test('should trigger the corresponding callback', () async {
        final args = {'errorCode': 100, 'message': 'fail', 'consentViewType': 'pre'};
        final expected =
            IronSourceConsentViewError(errorCode: 100, message: 'fail', consentViewType: 'pre');
        await IronSource.handleMethodCall(MethodCall('consentViewDidFailToLoad', args));
        verify(mockConsentViewListener.consentViewDidFailToLoad(expected)).called(1);
      });
    });
    group('consentViewDidShowSuccess', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(
            MethodCall('consentViewDidShowSuccess', {'consentViewType': 'pre'}));
        verify(mockConsentViewListener.consentViewDidShowSuccess('pre')).called(1);
      });
    });
    group('consentViewDidFailToShow', () {
      test('should trigger the corresponding callback', () async {
        final args = {'errorCode': 100, 'message': 'fail', 'consentViewType': 'pre'};
        final expected =
            IronSourceConsentViewError(errorCode: 100, message: 'fail', consentViewType: 'pre');
        await IronSource.handleMethodCall(MethodCall('consentViewDidFailToShow', args));
        verify(mockConsentViewListener.consentViewDidFailToShow(expected)).called(1);
      });
    });
    group('consentViewDidAccept', () {
      test('should trigger the corresponding callback', () async {
        await IronSource.handleMethodCall(
            MethodCall('consentViewDidAccept', {'consentViewType': 'pre'}));
        verify(mockConsentViewListener.consentViewDidAccept('pre')).called(1);
      });
    });
  });

  tearDown(() {
    IronSource.setListeners(
        rewardedVideoListener: null,
        interstitialListener: null,
        bannerListener: null,
        offerwallListener: null,
        impressionDataListener: null,
        consentViewListener: null);
  });
}
