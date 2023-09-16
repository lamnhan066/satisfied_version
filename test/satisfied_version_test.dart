import 'package:satisfied_version/satisfied_version.dart';
import 'package:satisfied_version/src/conparator.dart';
import 'package:test/test.dart';

void main() {
  const String appVersion = '1.0.0';
  const Map<String, bool> testStringWithCondition = {
    // >
    '>1.0.0': false,
    '>0.0.9': true,
    '>1.0.1': false,
    '>0.0.10': true,
    '>0.100.100': true,
    // <
    '<1.0.0': false,
    '<0.0.9': false,
    '<1.0.1': true,
    '<0.0.10': false,
    '<0.100.100': false,
    // >=
    '>=1.0.0': true,
    '>=1.0.1': false,
    '>=0.0.9': true,
    '>=0.0.10': true,
    '>=0.100.100': true,
    // <=
    '<=1.0.0': true,
    '<=1.0.1': true,
    '<=0.0.9': false,
    '<=0.0.10': false,
    '<=0.100.100': false,
    // =
    '=1.0.0': true,
    '=1.0.1': false,
    '=0.0.9': false,
    '=0.0.10': false,
    '=0.100.100': false,
    // ==
    '==1.0.0': true,
    '==1.0.1': false,
    '==0.0.9': false,
    '==0.0.10': false,
    '==0.100.100': false,
    // Default is SatisfiedCondition.equal
    '1.0.0': true,
    '1.0.1': false,
    '0.0.9': false,
  };

  const List<String> conditionList = ['<1.0.0', '>=1.0.2'];
  const Map<String, bool> testList = {
    '1.0.0': false,
    '1.0.3': true,
    '0.0.900': true,
  };

  const List<String> conditionListWithin = [
    '>1.0.0',
    '<1.5.0',
    '1.6.0',
    '>=2.0.0',
    '<2.0.2'
  ];
  const Map<String, bool> testListWithin = {
    '1.0.0': false,
    '1.1.0': true,
    '1.5.1': false,
    '1.6.0': true,
    '2.0.1': true,
    '2.0.2': false,
  };

  const Map<String, bool> conditionMap = {
    '<1.0.0': true,
    '>=1.0.2': false,
    '>=2.0.0': true,
    '>=2.0.1': false,
  };
  const Map<String, bool> testMap = {
    '1.0.0': false,
    '1.0.3': false,
    '0.0.9': true,
  };

  group('Comparator', () {
    test('isGreater', () {
      final comparator = Comparator(version: '1.1.0');
      final other = Comparator(version: '1.0.0');
      expect(comparator.isGreater(other), equals(true));
      expect(other.isGreater(comparator), equals(false));

      final comparator1 = Comparator(version: '0.0.101');
      final other1 = Comparator(version: '0.0.9');
      expect(comparator1.isGreater(other1), equals(true));
      expect(other1.isGreater(comparator1), equals(false));
    });
    test('isGreaterEqual', () {
      final comparator = Comparator(version: '1.0.3');
      final other = Comparator(version: '1.0.2');
      expect(comparator.isGreaterEqual(other), equals(true));
      expect(other.isGreaterEqual(comparator), equals(false));
    });
    test('isLess', () {
      final comparator = Comparator(version: '1.0.0');
      final other = Comparator(version: '1.1.0');
      expect(comparator.isLess(other), equals(true));
      expect(other.isLess(comparator), equals(false));
    });
    test('isLessEqual', () {
      final comparator = Comparator(version: '1.0.2');
      final other = Comparator(version: '1.1.2');
      expect(comparator.isLessEqual(other), equals(true));
      expect(other.isLessEqual(comparator), equals(false));
    });
  });

  group('SatisfiedVersion', () {
    test('unsupported extension type', () {
      expect(() => '1.0.0'.satisfiedWith(100), throwsUnsupportedError);
    });

    test('satisfiedWith', () {
      testStringWithCondition.forEach((conditionString, expectResult) {
        final result = SatisfiedVersion.string(appVersion, conditionString);

        expect(result, equals(expectResult));

        // Extension
        expect(appVersion.satisfiedWith(conditionString), equals(expectResult));
      });
    });

    test('satisfiedList', () {
      testList.forEach((version, expectResult) {
        final result = SatisfiedVersion.list(version, conditionList);

        expect(result, equals(expectResult));

        // Extension
        expect(version.satisfiedWith(conditionList), equals(expectResult));
      });
    });

    test('satisfiedList Within', () {
      testListWithin.forEach((version, expectResult) {
        final result = SatisfiedVersion.list(version, conditionListWithin);

        expect(
          result,
          equals(expectResult),
        );

        // Extension
        expect(
            version.satisfiedWith(conditionListWithin), equals(expectResult));
      });
    });

    test('satisfiedMap', () {
      testMap.forEach((version, expectResult) {
        expect(
            SatisfiedVersion.map(version, conditionMap), equals(expectResult));

        // Extension
        expect(version.satisfiedWith(conditionMap), equals(expectResult));
      });

      expect(
        SatisfiedVersion.map('1.0.9', conditionMap, preferTrue: true),
        equals(false),
      );
      expect(
        SatisfiedVersion.map('2.0.5', conditionMap, preferTrue: true),
        equals(true),
      );
      expect(
        SatisfiedVersion.map('2.0.5', conditionMap, preferTrue: false),
        equals(false),
      );
    });
  });
}
