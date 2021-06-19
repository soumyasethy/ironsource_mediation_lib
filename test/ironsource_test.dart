import 'package:flutter_test/flutter_test.dart';
import 'package:ironsource_mediation/src/ironsource.dart';

void main() {
  group('IronSourceAdUnit', () {
    group('parse', () {
      group('with RewardedVideo,', () {
        test('should return a correct string', () {
          final actual = IronSourceAdUnit.RewardedVideo.parse();
          final expected = "REWARDED_VIDEO";
          expect(actual, expected);
        });
      });
      group('with Interstitial,', () {
        test('should return a correct string', () {
          final actual = IronSourceAdUnit.Interstitial.parse();
          final expected = "INTERSTITIAL";
          expect(actual, expected);
        });
      });
      group('with Offerwall,', () {
        test('should return a correct string', () {
          final actual = IronSourceAdUnit.Offerwall.parse();
          final expected = "OFFERWALL";
          expect(actual, expected);
        });
      });
      group('with Banner,', () {
        test('should return a correct string', () {
          final actual = IronSourceAdUnit.Banner.parse();
          final expected = "BANNER";
          expect(actual, expected);
        });
      });
    });
  });

  group('IronSourceBannerPosition', () {
    group('toInt', () {
      group('with Top position', () {
        test('should return 0', () {
          final actual = IronSourceBannerPosition.Top.toInt();
          final expected = 0;
          expect(actual, expected);
        });
      });
      group('with Center position', () {
        test('should return 1', () {
          final actual = IronSourceBannerPosition.Center.toInt();
          final expected = 1;
          expect(actual, expected);
        });
      });
      group('with Bottom position', () {
        test('should return 2', () {
          final actual = IronSourceBannerPosition.Bottom.toInt();
          final expected = 2;
          expect(actual, expected);
        });
      });
    });
  });
}
