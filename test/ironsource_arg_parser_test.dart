import 'package:flutter_test/flutter_test.dart';
import 'package:ironsource_mediation/src/ironsource.dart';
import 'package:ironsource_mediation/src/ironsource_arg_parser.dart';
import 'package:ironsource_mediation/src/ironsource_impression_data.dart';
import 'package:ironsource_mediation/src/ironsource_ow_credit_info.dart';
import 'package:ironsource_mediation/src/ironsource_segment.dart';
import 'package:ironsource_mediation/src/ironsource_banner_size.dart';
import 'package:ironsource_mediation/src/ironsource_error.dart';

void main() {
  /// Util =======================================================================
  group('ParserUtil', () {
    group('getArgumentValueWithKey', () {
      group('with valid arguments,', () {
        test('should return a value in the specified type', () {
          final key = 'someKey';
          final value = 'Value String';
          final arguments = {key: value};
          final actual = ParserUtil.getArgumentValueWithKey<String>(key, arguments);
          final expected = value;
          expect(actual, expected);
        });
      });
      group('with non-Map arguments,', () {
        test('should throw Error', () {
          final key = 'someKey';
          final arguments = "hello";
          expect(() => ParserUtil.getArgumentValueWithKey<String>(key, arguments),
              throwsA(isInstanceOf<Error>()));
        });
      });
      group('with arguments not contain the key of non-nullable value,', () {
        test('should throw Error', () {
          final key = 'someKey';
          final arguments = {"hello": 1.0};
          expect(() => ParserUtil.getArgumentValueWithKey<double>(key, arguments),
              throwsA(isInstanceOf<ArgumentError>()));
        });
      });
      group('with arguments not contain the key of nullable value,', () {
        test('should return null', () {
          final key = 'keyOfNullable';
          final arguments = {"otherKey": "hello"};
          final actual = ParserUtil.getArgumentValueWithKey<String?>(key, arguments);
          final expected = null;
          expect(actual, expected);
        });
      });
      group('with arguments not contain the value of the specified type,', () {
        test('should throw Error', () {
          final key = 'someKey';
          final arguments = {key: 1.0};
          expect(() => ParserUtil.getArgumentValueWithKey<String>(key, arguments),
              throwsA(isInstanceOf<ArgumentError>()));
        });
      });
    });

    group('isNullable', () {
      group('with a nullable type in the arg,', () {
        test('should return true', () {
          final actual = ParserUtil.isNullable<String?>();
          final expected = true;
          expect(actual, expected);
        });
      });
      group('with a non-null type in the arg,', () {
        test('should return false', () {
          final actual = ParserUtil.isNullable<String>();
          final expected = false;
          expect(actual, expected);
        });
      });
    });

    group('nullOrValue', () {
      group('with null in the arg,', () {
        test('should return null', () {
          final actual = ParserUtil.nullOrValue<String, String>(null, (String str) => str);
          final expected = null;
          expect(actual, expected);
        });
      });
      group('with a non-null value in the arg,', () {
        test('should return value of the callback', () {
          final actual = ParserUtil.nullOrValue<int, String>(2, (int n) => n.toString());
          final expected = '2';
          expect(actual, expected);
        });
      });
    });

    group('getRVPlacementFromArguments', () {
      group('with valid arguments,', () {
        test('should return an instance of IronSourceRVPlacement', () {
          final placementName = 'test placement';
          final rewardName = 'Virtual item';
          final rewardAmount = 3;
          final arguments = {
            'placementName': placementName,
            'rewardName': rewardName,
            'rewardAmount': rewardAmount
          };
          final actual = ParserUtil.getRVPlacementFromArguments(arguments);
          expect(actual.placementName, placementName);
          expect(actual.rewardName, rewardName);
          expect(actual.rewardAmount, rewardAmount);
        });
      });
      group('with invalid arguments,', () {
        test('should throw ArgumentError', () {
          final arguments = {'no-such': 10};
          expect(() => ParserUtil.getRVPlacementFromArguments(arguments),
              throwsA(isInstanceOf<ArgumentError>()));
        });
      });
    });

    group('getIronSourceErrorFromArguments', () {
      group('with valid arguments,', () {
        test('should return an instance of IronSourceError', () {
          final errorCode = 508;
          final message = 'init failure';
          final arguments = {
            'errorCode': errorCode,
            'message': message,
          };
          final actual = ParserUtil.getIronSourceErrorFromArguments(arguments);
          expect(actual.errorCode, errorCode);
          expect(actual.message, message);
          final argumentsNullable = {};
          final actualNullable = ParserUtil.getIronSourceErrorFromArguments(argumentsNullable);
          expect(actualNullable.errorCode, null);
          expect(actualNullable.message, null);
        });
      });
      group('with non-map invalid arguments,', () {
        test('should throw Error', () {
          final arguments = "hello";
          expect(() => IronSourceArgParser.onRewardedVideoAdShowFailed(arguments),
              throwsA(isInstanceOf<Error>()));
        });
      });
    });
  });

  /// IronSourceArgParser =====================================================
  /// Base API ================================================================
  group('IronSourceArgParser', () {
    group('shouldTrackNetworkState', () {
      test('should return a Map with isEnabled bool', () {
        final isEnabled1 = true;
        final actual1 = IronSourceArgParser.shouldTrackNetworkState(isEnabled1);
        final expected1 = {'isEnabled': isEnabled1};
        expect(actual1, expected1);

        final isEnabled2 = false;
        final actual2 = IronSourceArgParser.shouldTrackNetworkState(isEnabled2);
        final expected2 = {'isEnabled': isEnabled2};
        expect(actual2, expected2);
      });
    });

    group('setAdaptersDebug', () {
      test('should return a Map with isEnabled bool', () {
        final isEnabled1 = true;
        final actual1 = IronSourceArgParser.setAdaptersDebug(isEnabled1);
        final expected1 = {'isEnabled': isEnabled1};
        expect(actual1, expected1);

        final isEnabled2 = false;
        final actual2 = IronSourceArgParser.setAdaptersDebug(isEnabled2);
        final expected2 = {'isEnabled': isEnabled2};
        expect(actual2, expected2);
      });
    });

    group('setDynamicUserId', () {
      group('with a String argument', () {
        test('should return a Map with userId String', () {
          final userId = "some-test-user-id";
          final actual = IronSourceArgParser.setDynamicUserId(userId);
          final expected = {'userId': userId};
          expect(actual, expected);
        });
      });
    });

    group('setConsent', () {
      test('should return a Map with isConsent bool', () {
        final isConsent1 = true;
        final actual1 = IronSourceArgParser.setConsent(isConsent1);
        final expected1 = {'isConsent': isConsent1};
        expect(actual1, expected1);

        final isConsent2 = false;
        final actual2 = IronSourceArgParser.setConsent(isConsent2);
        final expected2 = {'isConsent': isConsent2};
        expect(actual2, expected2);
      });
    });

    group('setSegment', () {
      test('should return a Map with segment', () {
        final segment = IronSourceSegment();
        final actual = IronSourceArgParser.setSegment(segment);

        /// segment.toMap function is tested separately
        final expected = {'segment': segment.toMap()};
        expect(actual, expected);
      });
    });

    group('setMetaData', () {
      test('should return a metaData Map', () {
        final metaData = {
          'data1': ['value'],
          'data2': ['val1', 'val2']
        };
        final actual = IronSourceArgParser.setMetaData(metaData);
        final expected = {'metaData': metaData};
        expect(actual, expected);
      });
    });

    /// Init API ================================================================
    group('init', () {
      group('with adUnits in the args,', () {
        test('should return a Map with appKey and adUnits', () {
          final appKey = "testKey123";
          final adUnits = [IronSourceAdUnit.RewardedVideo];
          final actual = IronSourceArgParser.init(appKey: appKey, adUnits: adUnits);
          final expected = {
            'appKey': appKey,
            'adUnits': ["REWARDED_VIDEO"]
          };
          expect(actual, expected);
        });
      });

      group('with an empty array of adUnits in the args,', () {
        test('should return a Map with appKey', () {
          final appKey = "testKey123";
          final List<IronSourceAdUnit> adUnits = [];
          final actual = IronSourceArgParser.init(appKey: appKey, adUnits: adUnits);
          final expected = {'appKey': appKey};
          expect(actual, expected);
        });
      });

      group('without adUnits in the args,', () {
        test('should return a Map with appKey', () {
          final appKey = "testKey123";
          final actual = IronSourceArgParser.init(appKey: appKey);
          final expected = {'appKey': appKey};
          expect(actual, expected);
        });
      });
    });

    group('setUserId', () {
      group('with a String argument', () {
        test('should return a Map with userId String', () {
          final userId = "some-test-user-id";
          final actual = IronSourceArgParser.setUserId(userId);
          final expected = {'userId': userId};
          expect(actual, expected);
        });
      });
    });

    /// RV API ==================================================================
    group('showRewardedVideo', () {
      group('with a String argument', () {
        test('should return a Map with placementName String?', () {
          final placementName = "DefaultPlacement";
          final actual = IronSourceArgParser.showRewardedVideo(placementName);
          final expected = {'placementName': placementName};
          expect(actual, expected);
        });
      });
      group('with a null argument', () {
        test('should return an empty Map', () {
          final actual = IronSourceArgParser.showRewardedVideo(null);
          final expected = {};
          expect(actual, expected);
        });
      });
    });

    group('getRewardedVideoPlacementInfo', () {
      group('with a String argument', () {
        test('should return a Map with placementName String', () {
          final placementName = "DefaultPlacement";
          final actual = IronSourceArgParser.getRewardedVideoPlacementInfo(placementName);
          final expected = {'placementName': placementName};
          expect(actual, expected);
        });
      });
    });

    group('isRewardedVideoPlacementCapped', () {
      group('with a String argument', () {
        test('should return a Map with placementName String', () {
          final placementName = "DefaultPlacement";
          final actual = IronSourceArgParser.isRewardedVideoPlacementCapped(placementName);
          final expected = {'placementName': placementName};
          expect(actual, expected);
        });
      });
    });

    group('setRewardedVideoServerParams', () {
      group('with a Map argument', () {
        test('should return a Map with key:parameters', () {
          final params = {'paramKey': 'paramValue'};
          final actual = IronSourceArgParser.setRewardedVideoServerParams(params);
          final expected = {'parameters': params};
          expect(actual, expected);
        });
      });
    });

    /// IS API ==================================================================
    group('showInterstitial', () {
      group('with a String argument', () {
        test('should return a Map with placementName String?', () {
          final placementName = "DefaultPlacement";
          final actual = IronSourceArgParser.showInterstitial(placementName);
          final expected = {'placementName': placementName};
          expect(actual, expected);
        });
      });
      group('with a null argument', () {
        test('should return an empty Map', () {
          final actual = IronSourceArgParser.showInterstitial(null);
          final expected = {};
          expect(actual, expected);
        });
      });
    });

    group('isInterstitialPlacementCapped', () {
      group('with a String argument', () {
        test('should return a Map with placementName String', () {
          final placementName = "DefaultISPlacement";
          final actual = IronSourceArgParser.isInterstitialPlacementCapped(placementName);
          final expected = {'placementName': placementName};
          expect(actual, expected);
        });
      });
    });

    /// BN API ==================================================================
    group('loadBanner', () {
      group('with valid non-null arguments', () {
        test('should return a Map with respective params', () {
          final bannerSize = IronSourceBannerSize.BANNER;
          final position = IronSourceBannerPosition.Top;
          final placementName = "DefaultISPlacement";
          final offset = -50;
          final actual = IronSourceArgParser.loadBanner(bannerSize, position,
              offset: offset, placementName: placementName);
          final expected = {
            'description': bannerSize.description,
            'width': bannerSize.width,
            'height': bannerSize.height,
            'position': position.toInt(),
            'offset': offset,
            'placementName': placementName
          };
          expect(actual, expected);
        });
      });
      group('when offset is null', () {
        test('should return a Map without the offset key', () {
          final bannerSize = IronSourceBannerSize.BANNER;
          final position = IronSourceBannerPosition.Top;
          final placementName = "DefaultISPlacement";
          final actual =
              IronSourceArgParser.loadBanner(bannerSize, position, placementName: placementName);
          final expected = {
            'description': bannerSize.description,
            'width': bannerSize.width,
            'height': bannerSize.height,
            'position': position.toInt(),
            'placementName': placementName
          };
          expect(actual, expected);
        });
      });
      group('when placementName is null', () {
        test('should return a Map without the placementName key', () {
          final bannerSize = IronSourceBannerSize.BANNER;
          final position = IronSourceBannerPosition.Top;
          final actual = IronSourceArgParser.loadBanner(bannerSize, position);
          final expected = {
            'description': bannerSize.description,
            'width': bannerSize.width,
            'height': bannerSize.height,
            'position': position.toInt()
          };
          expect(actual, expected);
        });
      });
    });

    group('isBannerPlacementCapped', () {
      group('with a String argument', () {
        test('should return a Map with placementName String', () {
          final placementName = "DefaultBNPlacement";
          final actual = IronSourceArgParser.isBannerPlacementCapped(placementName);
          final expected = {'placementName': placementName};
          expect(actual, expected);
        });
      });
    });

    /// OW API ==================================================================
    group('showOfferwall', () {
      group('with a String argument', () {
        test('should return a Map with placementName String', () {
          final placementName = "DefaultPlacement";
          final actual = IronSourceArgParser.showOfferwall(placementName);
          final expected = {'placementName': placementName};
          expect(actual, expected);
        });
      });
      group('with a null argument', () {
        test('should return an empty Map', () {
          final actual = IronSourceArgParser.showOfferwall(null);
          final expected = {};
          expect(actual, expected);
        });
      });
    });

    /// Config API ===============================================================

    group('setClientSideCallbacks', () {
      test('should return a Map with isEnabled bool', () {
        final isEnabled1 = true;
        final actual1 = IronSourceArgParser.setClientSideCallbacks(isEnabled1);
        final expected1 = {'isEnabled': isEnabled1};
        expect(actual1, expected1);

        final isEnabled2 = false;
        final actual2 = IronSourceArgParser.setClientSideCallbacks(isEnabled2);
        final expected2 = {'isEnabled': isEnabled2};
        expect(actual2, expected2);
      });
    });

    group('setOfferwallCustomParams', () {
      group('with a Map argument', () {
        test('should return a Map with key:parameters', () {
          final params = {'paramKey': 'paramValue'};
          final actual = IronSourceArgParser.setOfferwallCustomParams(params);
          final expected = {'parameters': params};
          expect(actual, expected);
        });
      });
    });

    /// iOS14 ConsentView ======================================================
    group('loadConsentViewWithType', () {
      group('with valid arguments,', () {
        test('should return a string consentViewType', () {
          final arguments = 'pre';
          final actual = IronSourceArgParser.loadConsentViewWithType(arguments);
          final expected = {'consentViewType': 'pre'};
          expect(actual, expected);
        });
      });
    });

    group('showConsentViewWithType', () {
      group('with valid arguments,', () {
        test('should return a string consentViewType', () {
          final arguments = 'pre';
          final actual = IronSourceArgParser.showConsentViewWithType(arguments);
          final expected = {'consentViewType': 'pre'};
          expect(actual, expected);
        });
      });
    });

    /// Listener callbacks =======================================================
    ///
    /// RV =======================================================================
    group('onRewardedVideoAvailabilityChanged', () {
      group('with valid arguments,', () {
        test('should return a bool isAvailable', () {
          final arguments = {'isAvailable': true};
          final actual = IronSourceArgParser.onRewardedVideoAvailabilityChanged(arguments);
          final expected = true;
          expect(actual, expected);
        });
      });
      group('with invalid arguments,', () {
        test('should throw ArgumentError', () {
          final arguments = {'no-such': 10};
          expect(() => IronSourceArgParser.onRewardedVideoAvailabilityChanged(arguments),
              throwsA(isInstanceOf<ArgumentError>()));
        });
      });
    });

    group('onRewardedVideoAdRewarded', () {
      test('- omit: delegated functionality to getRVPlacementFromArguments', () {});
    });

    group('onRewardedVideoAdShowFailed', () {
      test('- omit: delegated functionality to getIronSourceErrorFromArguments', () {});
    });

    group('onRewardedVideoAdClicked', () {
      test('- omit: delegated functionality to getRVPlacementFromArguments', () {});
    });

    /// IS =======================================================================
    group('onInterstitialAdLoadFailed', () {
      test('- omit: delegated functionality to getIronSourceErrorFromArguments', () {});
    });

    group('onInterstitialAdShowFailed', () {
      test('- omit: delegated functionality to getIronSourceErrorFromArguments', () {});
    });

    /// BN =======================================================================
    group('onBannerAdLoadFailed', () {
      test('- omit: delegated functionality to getIronSourceErrorFromArguments', () {});
    });

    /// OW =======================================================================
    group('onOfferwallAvailabilityChanged', () {
      group('with valid arguments,', () {
        test('should return a bool isAvailable', () {
          final arguments = {'isAvailable': true};
          final actual = IronSourceArgParser.onOfferwallAvailabilityChanged(arguments);
          final expected = true;
          expect(actual, expected);
        });
      });
      group('with invalid arguments,', () {
        test('should throw ArgumentError', () {
          final arguments = {'no-such': 10};
          expect(() => IronSourceArgParser.onOfferwallAvailabilityChanged(arguments),
              throwsA(isInstanceOf<ArgumentError>()));
        });
      });
    });

    group('onOfferwallAdCredited', () {
      group('with valid arguments,', () {
        test('should return an IronSourceOWCreditInfo instance', () {
          final arguments = {'credits': 10, 'totalCredits': 100, 'totalCreditsFlag': false};
          final actual = IronSourceArgParser.onOfferwallAdCredited(arguments);
          final expected =
              IronSourceOWCreditInfo(credits: 10, totalCredits: 100, totalCreditsFlag: false);
          expect(actual, expected);
        });
      });
      group('with null arguments,', () {
        test('should throw ArgumentError', () {
          final arguments = null;
          expect(() => IronSourceArgParser.onOfferwallAdCredited(arguments),
              throwsA(isInstanceOf<ArgumentError>()));
        });
      });
    });

    group('onOfferwallShowFailed', () {
      test('- omit: delegated functionality to getIronSourceErrorFromArguments', () {});
    });

    group('onGetOfferwallCreditsFailed', () {
      test('- omit: delegated functionality to getIronSourceErrorFromArguments', () {});
    });

    /// ImpressionData ===========================================================
    ///
    group('onImpressionSuccess', () {
      group('with valid arguments,', () {
        test('should return an IronSourceImpressionData instance', () {
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
          final actual = IronSourceArgParser.onImpressionSuccess(arguments);
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
          expect(actual, expected);
        });
      });
      group('with null arguments,', () {
        test('should return null', () {
          final arguments = null;
          final actual = IronSourceArgParser.onImpressionSuccess(arguments);
          final expected = null;
          expect(actual, expected);
        });
      });
    });

    /// iOS14 ConsentView ======================================================

    group('consentViewDidLoadSuccess', () {
      group('with valid arguments,', () {
        test('should return a string consentViewType', () {
          final arguments = {'consentViewType': 'pre'};
          final actual = IronSourceArgParser.consentViewDidLoadSuccess(arguments);
          final expected = 'pre';
          expect(actual, expected);
        });
      });
      group('with arguments with no value,', () {
        test('should return an empty string consentViewType', () {
          final arguments = {};
          final actual = IronSourceArgParser.consentViewDidLoadSuccess(arguments);
          final expected = '';
          expect(actual, expected);
        });
      });
    });

    group('consentViewDidFailToLoad', () {
      group('with valid arguments,', () {
        test('should return an IronSourceConsentViewError', () {
          final arguments = {'errorCode': 510, 'message': 'failed', 'consentViewType': 'pre'};
          final actual = IronSourceArgParser.consentViewDidFailToLoad(arguments);
          final expected =
              IronSourceConsentViewError(errorCode: 510, message: 'failed', consentViewType: 'pre');
          expect(actual, expected);
        });
      });
      group('with arguments with no value,', () {
        test('should return an IronSourceConsentViewError with empty string', () {
          final arguments = {};
          final actual = IronSourceArgParser.consentViewDidFailToLoad(arguments);
          final expected = IronSourceConsentViewError(consentViewType: '');
          expect(actual, expected);
        });
      });
    });

    group('consentViewDidShowSuccess', () {
      group('with valid arguments,', () {
        test('should return a string consentViewType', () {
          final arguments = {'consentViewType': 'pre'};
          final actual = IronSourceArgParser.consentViewDidShowSuccess(arguments);
          final expected = 'pre';
          expect(actual, expected);
        });
      });
      group('with arguments with no value,', () {
        test('should return an empty string consentViewType', () {
          final arguments = {};
          final actual = IronSourceArgParser.consentViewDidShowSuccess(arguments);
          final expected = '';
          expect(actual, expected);
        });
      });
    });

    group('consentViewDidFailToShow', () {
      group('with valid arguments,', () {
        test('should return a string consentViewType', () {
          final arguments = {'errorCode': 510, 'message': 'failed', 'consentViewType': 'pre'};
          final actual = IronSourceArgParser.consentViewDidFailToShow(arguments);
          final expected =
              IronSourceConsentViewError(errorCode: 510, message: 'failed', consentViewType: 'pre');
          expect(actual, expected);
        });
      });
      group('with arguments with no value,', () {
        test('should return an empty string consentViewType', () {
          final arguments = {};
          final actual = IronSourceArgParser.consentViewDidFailToShow(arguments);
          final expected = IronSourceConsentViewError(consentViewType: '');
          expect(actual, expected);
        });
      });
    });

    group('consentViewDidAccept', () {
      group('with valid arguments,', () {
        test('should return a string consentViewType', () {
          final arguments = {'consentViewType': 'pre'};
          final actual = IronSourceArgParser.consentViewDidAccept(arguments);
          final expected = 'pre';
          expect(actual, expected);
        });
      });
      group('with arguments with no value,', () {
        test('should return an empty string consentViewType', () {
          final arguments = {};
          final actual = IronSourceArgParser.consentViewDidAccept(arguments);
          final expected = '';
          expect(actual, expected);
        });
      });
    });
  });
}
