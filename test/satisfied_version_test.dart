import 'package:satisfied_version/satisfied_version.dart';
import 'package:test/test.dart';

void main() {
  group('SatisfiedVersion', () {
    test('isSatisfiedVersion', () {
      const appVersion = '1.0.0';

      expect(SatisfiedVersion.isSatisfied(appVersion, '>1.0.0'), equals(false));
      expect(SatisfiedVersion.isSatisfied(appVersion, '>0.0.9'), equals(true));
      expect(SatisfiedVersion.isSatisfied(appVersion, '>1.0.1'), equals(false));

      expect(SatisfiedVersion.isSatisfied(appVersion, '<1.0.0'), equals(false));
      expect(SatisfiedVersion.isSatisfied(appVersion, '<0.0.9'), equals(false));
      expect(SatisfiedVersion.isSatisfied(appVersion, '<1.0.1'), equals(true));

      expect(SatisfiedVersion.isSatisfied(appVersion, '>=1.0.0'), equals(true));
      expect(
          SatisfiedVersion.isSatisfied(appVersion, '>=1.0.1'), equals(false));
      expect(SatisfiedVersion.isSatisfied(appVersion, '>=0.0.9'), equals(true));

      expect(SatisfiedVersion.isSatisfied(appVersion, '<=1.0.0'), equals(true));
      expect(SatisfiedVersion.isSatisfied(appVersion, '<=1.0.1'), equals(true));
      expect(
          SatisfiedVersion.isSatisfied(appVersion, '<=0.0.9'), equals(false));

      expect(SatisfiedVersion.isSatisfied(appVersion, '=1.0.0'), equals(true));
      expect(SatisfiedVersion.isSatisfied(appVersion, '=1.0.1'), equals(false));
      expect(SatisfiedVersion.isSatisfied(appVersion, '=0.0.9'), equals(false));

      expect(SatisfiedVersion.isSatisfied(appVersion, '==1.0.0'), equals(true));
      expect(
          SatisfiedVersion.isSatisfied(appVersion, '==1.0.1'), equals(false));
      expect(
          SatisfiedVersion.isSatisfied(appVersion, '==0.0.9'), equals(false));

      expect(SatisfiedVersion.isSatisfied(appVersion, '1.0.0'), equals(true));
      expect(SatisfiedVersion.isSatisfied(appVersion, '1.0.1'), equals(false));
      expect(SatisfiedVersion.isSatisfied(appVersion, '0.0.9'), equals(false));
    });

    test('satisfiedList', () {
      const versions = ['<1.0.0', '>=1.0.2'];

      expect(SatisfiedVersion.list('1.0.0', versions), equals(false));
      expect(SatisfiedVersion.list('1.0.3', versions), equals(true));
      expect(SatisfiedVersion.list('0.0.9', versions), equals(true));
    });

    test('satisfiedMap', () {
      const versions = {
        '<1.0.0': true,
        '>=1.0.2': false,
        '>=2.0.0': true,
        '>=2.0.1': false,
      };

      expect(SatisfiedVersion.map('1.0.0', versions), equals(false));
      expect(SatisfiedVersion.map('1.0.3', versions), equals(false));
      expect(SatisfiedVersion.map('0.0.9', versions), equals(true));

      expect(
        SatisfiedVersion.map('1.0.9', versions, preferTrue: true),
        equals(false),
      );
      expect(
        SatisfiedVersion.map('2.0.5', versions, preferTrue: true),
        equals(true),
      );
      expect(
        SatisfiedVersion.map('2.0.5', versions, preferTrue: false),
        equals(false),
      );
    });
  });
}
