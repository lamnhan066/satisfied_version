import 'package:satisfied_version/satisfied_version.dart';
import 'package:test/test.dart';

void main() {
  group('SatisfiedVersion', () {
    const String appVersion = '1.0.0';
    const Map<String, bool> testStringWithCondition = {
      // >
      '>1.0.0': false,
      '>0.0.9': true,
      '>1.0.1': false,
      // <
      '<1.0.0': false,
      '<0.0.9': false,
      '<1.0.1': true,
      // >=
      '>=1.0.0': true,
      '>=1.0.1': false,
      '>=0.0.9': true,
      // <=
      '<=1.0.0': true,
      '<=1.0.1': true,
      '<=0.0.9': false,
      // =
      '=1.0.0': true,
      '=1.0.1': false,
      '=0.0.9': false,
      // ==
      '==1.0.0': true,
      '==1.0.1': false,
      '==0.0.9': false,
      // Default is SatisfiedCondition.equal
      '1.0.0': true,
      '1.0.1': false,
      '0.0.9': false,
    };

    const List<String> conditionList = ['<1.0.0', '>=1.0.2'];
    const Map<String, bool> testList = {
      '1.0.0': false,
      '1.0.3': true,
      '0.0.9': true,
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

    test('satisfiedWith', () {
      testStringWithCondition.forEach((conditionString, expectResult) {
        expect(
          SatisfiedVersion.string(appVersion, conditionString),
          equals(expectResult),
        );

        // Extension
        expect(appVersion.satisfiedWith(conditionString), equals(expectResult));
      });
    });

    test('satisfiedList', () {
      testList.forEach((version, expectResult) {
        expectLater(SatisfiedVersion.list(version, conditionList),
            equals(expectResult));

        // Extension
        expect(version.satisfiedWith(conditionList), equals(expectResult));
      });

      testListWithin.forEach((version, expectResult) {
        expect(SatisfiedVersion.list(version, conditionListWithin),
            equals(expectResult));

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
