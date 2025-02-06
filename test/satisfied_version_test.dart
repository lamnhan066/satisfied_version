import 'package:satisfied_version/satisfied_version.dart';
import 'package:satisfied_version/src/comparator.dart';
import 'package:test/test.dart';

void main() {
  group('Comparator', () {
    test('isGreater', () {
      final comparator = Comparator(version: '1.1.0');
      final other = Comparator(version: '1.0.0');
      expect(comparator > other, equals(true));
      expect(other > comparator, equals(false));

      final comparator1 = Comparator(version: '0.0.101');
      final other1 = Comparator(version: '0.0.9');
      expect(comparator1 > other1, equals(true));
      expect(other1 > comparator1, equals(false));

      final comparator2 = Comparator(version: '2.0.0');
      final other2 = Comparator(version: '1.9.9');
      expect(comparator2 > other2, equals(true));
    });

    test('isGreaterEqual', () {
      final comparator = Comparator(version: '1.0.3');
      final other = Comparator(version: '1.0.2');
      expect(comparator >= other, equals(true));
      expect(other >= comparator, equals(false));

      final comparator1 = Comparator(version: '1.0.3');
      expect(comparator1 >= comparator1, equals(true));
    });

    test('isLess', () {
      final comparator = Comparator(version: '1.0.0');
      final other = Comparator(version: '1.1.0');
      expect(comparator < other, equals(true));
      expect(other < comparator, equals(false));
    });

    test('isLessEqual', () {
      final comparator = Comparator(version: '1.0.2');
      final other = Comparator(version: '1.1.2');
      expect(comparator <= other, equals(true));
      expect(other <= comparator, equals(false));
    });

    test('equal', () {
      final comparator = Comparator(version: '1.0.0');
      final other = Comparator(version: '1.0.0');
      expect(comparator == other, equals(true));
      expect(comparator != other, equals(false));
    });

    test('different', () {
      final comparator = Comparator(version: '1.0.0');
      final other = Comparator(version: '1.0.1');
      expect(comparator == other, equals(false));
      expect(comparator != other, equals(true));
    });

    test('Leading zeros', () {
      final comparator = Comparator(version: '1.01.0');
      final other = Comparator(version: '1.1.0');
      expect(comparator == other, equals(true));
    });

    test('Same major & minor, different patch', () {
      final comparator = Comparator(version: '1.0.0');
      final other = Comparator(version: '1.0.1');
      expect(comparator < other, equals(true));
    });

    test('Zero handling', () {
      final comparator = Comparator(version: '0.0.0');
      final other = Comparator(version: '0.0.1');
      expect(comparator < other, equals(true));
    });

    test('Negative version handling', () {
      expect(() => Comparator(version: '-1.0.0'), throwsFormatException);
      expect(() => Comparator(version: '1.-1.0'), throwsFormatException);
    });

    test('Invalid version handling', () {
      expect(() => Comparator(version: 'invalid'), throwsFormatException);
      expect(() => Comparator(version: ''), throwsFormatException);
      expect(() => Comparator(version: '1..0.0'), throwsFormatException);
    });
  });

  group('SatisfiedVersion.number', () {
    final numberEqual = 100;
    final numberLess = 99;
    final numberGreater = 101;
    final numberCompareWith = 100;

    test('Equal', () {
      final compareWith = '=$numberCompareWith';
      expect(numberEqual.satisfiedWith(compareWith), equals(true));
      expect(numberGreater.satisfiedWith(compareWith), equals(false));
      expect(numberLess.satisfiedWith(compareWith), equals(false));
    });

    test('Different', () {
      final compareWith = '!=$numberCompareWith';
      expect(numberEqual.satisfiedWith(compareWith), equals(false));
      expect(numberGreater.satisfiedWith(compareWith), equals(true));
      expect(numberLess.satisfiedWith(compareWith), equals(true));
    });

    test('Greater', () {
      final compareWith = '>$numberCompareWith';
      expect(numberEqual.satisfiedWith(compareWith), equals(false));
      expect(numberGreater.satisfiedWith(compareWith), equals(true));
      expect(numberLess.satisfiedWith(compareWith), equals(false));
    });

    test('GreaterEqual', () {
      final compareWith = '>=$numberCompareWith';
      expect(numberEqual.satisfiedWith(compareWith), equals(true));
      expect(numberGreater.satisfiedWith(compareWith), equals(true));
      expect(numberLess.satisfiedWith(compareWith), equals(false));
    });

    test('Less', () {
      final compareWith = '<$numberCompareWith';
      expect(numberEqual.satisfiedWith(compareWith), equals(false));
      expect(numberGreater.satisfiedWith(compareWith), equals(false));
      expect(numberLess.satisfiedWith(compareWith), equals(true));
    });

    test('LessEqual', () {
      final compareWith = '<=$numberCompareWith';
      expect(numberEqual.satisfiedWith(compareWith), equals(true));
      expect(numberGreater.satisfiedWith(compareWith), equals(false));
      expect(numberLess.satisfiedWith(compareWith), equals(true));
    });

    test('Zero handling', () {
      expect(0.satisfiedWith(['>0']), equals(false));
    });

    test('Negative numbers', () {
      expect((-1).satisfiedWith(['>=0']), equals(false));
    });

    test('Invalid condition', () {
      final compareWith = 'invalid';
      expect(
          () => numberEqual.satisfiedWith(compareWith), throwsFormatException);
    });
  });

  group('SatisfiedVersion', () {
    test('createString', () {
      expect(
        SatisfiedVersion.createString(SatisfiedCondition.greaterEqual, '1.0.0'),
        equals('>=1.0.0'),
      );
    });

    test('createNumber', () {
      expect(
        SatisfiedVersion.createNumber(SatisfiedCondition.greaterEqual, 100),
        equals('>=100'),
      );
    });
  });

  group('SatisfiedVersion String', () {
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
      // !=
      '!=1.0.0': false,
      '!=1.0.1': true,
      '!=0.0.9': true,
      '!=0.0.10': true,
      '!=0.100.100': true,
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
    const Map<String, bool> testMapWhenDefaultIsFalse = {
      '1.0.0': false,
      '1.0.3': false,
      '0.0.9': true,
    };
    const Map<String, bool> testMapWhenDefaultIsTrue = {
      '1.0.0': true,
      '1.0.3': false,
      '0.0.9': true,
    };

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
        expect(result, equals(expectResult));
        // Extension
        expect(
            version.satisfiedWith(conditionListWithin), equals(expectResult));
      });
    });

    test('satisfiedMap', () {
      testMapWhenDefaultIsFalse.forEach((version, expectResult) {
        expect(SatisfiedVersion.map(version, conditionMap, defaultValue: false),
            equals(expectResult));
        // Extension
        expect(version.satisfiedWith(conditionMap), equals(expectResult));
      });

      testMapWhenDefaultIsTrue.forEach((version, expectResult) {
        expect(SatisfiedVersion.map(version, conditionMap, defaultValue: true),
            equals(expectResult));
        // Extension
        expect(version.satisfiedWith(conditionMap, defaultValue: true),
            equals(expectResult));
      });
    });
  });

  group('SatisfiedVersion Number', () {
    const appVersion = 100;
    const Map<String, bool> testStringWithCondition = {
      // >
      '>100': false,
      '>99': true,
      '>101': false,
      // <
      '<100': false,
      '<99': false,
      '<101': true,
      // >=
      '>=100': true,
      '>=101': false,
      '>=99': true,
      // <=
      '<=100': true,
      '<=101': true,
      '<=99': false,
      // =
      '=100': true,
      '=101': false,
      '=99': false,
      // ==
      '==100': true,
      '==101': false,
      '==99': false,
      // !=
      '!=100': false,
      '!=101': true,
      '!=99': true,
      // Default is SatisfiedConditionequal
      '100': true,
      '101': false,
      '99': false,
    };

    const List<String> conditionList = ['<100', '>=102'];
    const Map<int, bool> testList = {
      100: false,
      103: true,
      99: true,
    };

    const List<String> conditionListWithin = [
      '>100',
      '<150',
      '160',
      '>=200',
      '<202'
    ];
    const Map<int, bool> testListWithin = {
      100: false,
      110: true,
      151: false,
      160: true,
      201: true,
      202: false,
    };

    const Map<String, bool> conditionMap = {
      '<100': true,
      '>=102': false,
      '>=200': true,
      '>=201': false,
    };
    const Map<int, bool> testMapWhenDefaultIsFalse = {
      100: false,
      103: false,
      99: true,
    };
    const Map<int, bool> testMapWhenDefaultIsTrue = {
      100: true,
      103: false,
      99: true,
    };

    test('unsupported extension type', () {
      expect(() => 100.satisfiedWith(100), throwsUnsupportedError);
    });

    test('satisfiedWith', () {
      testStringWithCondition.forEach((conditionString, expectResult) {
        final result = SatisfiedVersion.number(appVersion, conditionString);
        expect(result, equals(expectResult));
        // Extension
        expect(appVersion.satisfiedWith(conditionString), equals(expectResult));
      });
    });

    test('satisfiedList', () {
      testList.forEach((version, expectResult) {
        final result = SatisfiedVersion.listNumber(version, conditionList);
        expect(result, equals(expectResult));
        // Extension
        expect(version.satisfiedWith(conditionList), equals(expectResult));
      });
    });

    test('satisfiedList Within', () {
      testListWithin.forEach((version, expectResult) {
        final result =
            SatisfiedVersion.listNumber(version, conditionListWithin);
        expect(result, equals(expectResult));
        // Extension
        expect(
            version.satisfiedWith(conditionListWithin), equals(expectResult));
      });
    });

    test('satisfiedMap', () {
      testMapWhenDefaultIsFalse.forEach((version, expectResult) {
        expect(
            SatisfiedVersion.mapNumber(version, conditionMap,
                defaultValue: false),
            equals(expectResult));
        // Extension
        expect(version.satisfiedWith(conditionMap), equals(expectResult));
      });

      testMapWhenDefaultIsTrue.forEach((version, expectResult) {
        expect(
            SatisfiedVersion.mapNumber(version, conditionMap,
                defaultValue: true),
            equals(expectResult));
        // Extension
        expect(version.satisfiedWith(conditionMap, defaultValue: true),
            equals(expectResult));
      });
    });
  });
}
