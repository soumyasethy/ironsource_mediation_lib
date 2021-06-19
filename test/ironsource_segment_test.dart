import 'package:flutter_test/flutter_test.dart';
import 'package:ironsource_mediation/src/ironsource_segment.dart';
import 'package:logger/logger.dart';

void main() {
  setUp(() {
    Logger.level = Level.wtf; // suppress warning log
  });

  group('setCustom:', () {
    group('a segment with less than 5 custom params', () {
      test('should successfully set the arg param and return true', () {
        final segment = IronSourceSegment();
        final actualReturn = segment.setCustom(key: 'demoKey', value: 'testVal');
        final expectedReturn = true;
        expect(actualReturn, expectedReturn);
        final actualVal = segment.customParameters['demoKey'];
        final expectedVal = 'testVal';
        expect(actualVal, expectedVal);
      });
    });
    group('a segment with more than 5 custom params', () {
      test('should return false without setting the arg param', () {
        final segment = IronSourceSegment();
        for (var i in [1, 2, 3, 4, 5]) {
          segment.setCustom(key: 'demoKey$i', value: 'testVal$i');
        }
        final actualReturn = segment.setCustom(key: 'demoKey6', value: 'testVal6');
        final expectedReturn = false;
        expect(actualReturn, expectedReturn);
        final actualVal = segment.customParameters['demoKey6'];
        final expectedVal = null;
        expect(actualVal, expectedVal);
      });
    });
    group('with a key overlaps segment properties', () {
      test('should return false without setting the arg param', () {
        final segment = IronSourceSegment();
        for (var key in [
          'segmentName',
          'age',
          'gender',
          'level',
          'isPlaying',
          'userCreationDate',
          'iapTotal'
        ]) {
          final actualReturn = segment.setCustom(key: key, value: 'testVal');
          final expectedReturn = false;
          expect(actualReturn, expectedReturn);
          final actualVal = segment.customParameters[key];
          final expectedVal = null;
          expect(actualVal, expectedVal);
        }
      });
    });
  });

  group('toMap:', () {
    group('a segment with non-null properties', () {
      test('should return a Map with respective values', () {
        final segment = IronSourceSegment();
        segment.segmentName = 'DemoSegment';
        segment.age = 20;
        segment.gender = IronSourceUserGender.Female;
        segment.level = 10;
        segment.isPaying = false;
        segment.userCreationDateInMillis = DateTime.parse('2021-05-11').microsecondsSinceEpoch;
        segment.iapTotal = 100.00;
        segment.setCustom(key: 'customParam', value: 'testVal');
        final actual = segment.toMap();
        final expected = {
          'segmentName': 'DemoSegment',
          'age': 20,
          'gender': 'female',
          'level': 10,
          'isPaying': false,
          'userCreationDate': DateTime.parse('2021-05-11').microsecondsSinceEpoch,
          'iapTotal': 100.00,
          'customParam': 'testVal'
        };
        expect(actual, expected);
      });
    });
    group('a segment with null properties', () {
      test('should return a Map with no null properties', () {
        final segment = IronSourceSegment();
        final actual = segment.toMap();
        final expected = {};
        expect(actual, expected);
      });
    });
  });
}
