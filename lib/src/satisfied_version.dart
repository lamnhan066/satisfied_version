import 'conparator.dart';
import 'satisfiled_condition.dart';

class SatisfiedVersion {
  /// Create a version with format ">=1.0.0" to avoid mistake.
  static String createString(SatisfiedCondition condition, String string) {
    return '${condition.asString}$string';
  }

  /// Create a build number with format ">=100" to avoid mistake.
  static String createNumber(SatisfiedCondition condition, int number) {
    return '${condition.asString}$number';
  }

  ///  Compare 2 numbers with conditions
  ///
  /// `SatisfiedVersion.number(100, '>=100')` => true
  /// `SatisfiedVersion.number(100, '<=100')` => true
  ///
  /// `SatisfiedVersion.number(100, '>100')` => false
  /// `SatisfiedVersion.number(101, '>100')` => true
  /// `SatisfiedVersion.number(100, '<100')` => false
  ///
  /// `SatisfiedVersion.number(100, '=100')` => true
  /// `SatisfiedVersion.number(100, '==100')` => true
  ///
  /// Default is return `number == compareWith`
  static bool number(
    /// This is normally your current app build number.
    int number,

    /// The version that has conditions to compare with `number`.
    String compareWith, {
    /// Default condition if `compareWith` doesn't have the condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    compareWith = compareWith.trim();

    // Add the condition to the version that does not starts with any condition
    if (!SatisfiedCondition.isStartWithCondition(compareWith)) {
      compareWith = '${defaultCondition.asString}$compareWith';
    }

    // Compare with 2 operator letters
    final compareWithNumber =
        int.tryParse(SatisfiedCondition.removeCondition(compareWith));

    if (compareWithNumber == null) {
      return throw FormatException(
          '`compareWith` must be an integer leading (or not) with a condition.');
    }

    switch (SatisfiedCondition.parse(compareWith)) {
      case SatisfiedCondition.equalSingle:
      case SatisfiedCondition.equal:
        return number == compareWithNumber;
      case SatisfiedCondition.greaterEqual:
        return number >= compareWithNumber;
      case SatisfiedCondition.lessEqual:
        return number <= compareWithNumber;
      case SatisfiedCondition.greater:
        return number > compareWithNumber;
      case SatisfiedCondition.less:
        return number < compareWithNumber;
    }
  }

  ///  Compare 2 versions with format (major.minor.patch) with conditions
  ///
  /// `SatisfiedVersion.string('1.0.0', '>=1.0.0')` => true
  /// `SatisfiedVersion.string('1.0.0', '<=1.0.0')` => true
  ///
  /// `SatisfiedVersion.string('1.0.0', '>1.0.0')` => false
  /// `SatisfiedVersion.string('1.0.1', '>1.0.0')` => true
  /// `SatisfiedVersion.string('1.0.0', '<1.0.0')` => false
  ///
  /// `SatisfiedVersion.string('1.0.0', '=1.0.0')` => true
  /// `SatisfiedVersion.string('1.0.0', '==1.0.0')` => true
  ///
  /// Default is return `appVersion == version`
  static bool string(
    /// This is normally your current app version.
    String version,

    /// The version that has conditions to compare with `version`.
    String compareWith, {
    /// Default condition if `compareWith` doesn't have the condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    version = version.trim();
    compareWith = compareWith.trim();

    // Add the condition to the version that does not starts with any condition
    if (!SatisfiedCondition.isStartWithCondition(compareWith)) {
      compareWith = '${defaultCondition.asString}$compareWith';
    }

    final comparator = Comparator(version: version);

    // Compare with 2 operator letters
    final otherComparator =
        Comparator(version: SatisfiedCondition.removeCondition(compareWith));

    switch (SatisfiedCondition.parse(compareWith)) {
      case SatisfiedCondition.equalSingle:
      case SatisfiedCondition.equal:
        return comparator == otherComparator;
      case SatisfiedCondition.greaterEqual:
        return comparator.isGreaterEqual(otherComparator);
      case SatisfiedCondition.lessEqual:
        return comparator.isLessEqual(otherComparator);
      case SatisfiedCondition.greater:
        return comparator.isGreater(otherComparator);
      case SatisfiedCondition.less:
        return comparator.isLess(otherComparator);
    }
  }

  /// Return `true` if there is any satisfied version in sources
  ///
  /// ``` dart
  /// const versions = ['<1.0.0', '>=1.0.2'];
  /// print(SatisfiedVersion.list('1.0.0', versions)); // => false
  /// print(SatisfiedVersion.list('1.0.3', versions)); // => true
  /// print(SatisfiedVersion.list('0.0.9', versions)); // => true
  /// ```
  ///
  /// Support value bettwen 2 versions
  /// ``` dart
  /// const versionsInside = ['>1.0.0', '<1.5.0', '>=2.0.0', '<2.0.2'];
  /// print(SatisfiedVersion.list('1.0.0', versionsInside)); // => false
  /// print(SatisfiedVersion.list('1.0.3', versionsInside)); // => true
  /// print(SatisfiedVersion.list('1.5.1', versionsInside)); // => false
  /// print(SatisfiedVersion.list('2.0.1', versionsInside)); // => true
  /// print(SatisfiedVersion.list('2.0.3', versionsInside)); // => false
  /// ```
  static bool list(
    /// This is normally your current app version.
    String version,

    /// The version that has conditions to compare with `version`.
    List<String> versionList, {
    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    final List<String> versionListCopy = [...versionList];

    // Sort the versionList by it's version
    versionListCopy.sort((a, b) {
      final aComparator =
          Comparator(version: SatisfiedCondition.removeCondition(a));
      final bComparator =
          Comparator(version: SatisfiedCondition.removeCondition(b));
      return aComparator.compareTo(bComparator);
    });

    bool? lastBool;
    bool? currentBool;
    for (final e in versionListCopy) {
      final condition =
          SatisfiedCondition.parse(e, defaultCondition: defaultCondition);

      // If current condition is greater or greaterEqual then set `lastBool` to null.
      // Means we put the starting point here.
      if (condition
          case SatisfiedCondition.greater || SatisfiedCondition.greaterEqual) {
        lastBool = null;

        // If the first comparison version is greater than `version` => stop comparing
        if (!string(version, e, defaultCondition: defaultCondition)) {
          break;
        }
      }

      currentBool = string(version, e, defaultCondition: defaultCondition);

      // If both values are true, the current version is in the two conditions.
      if (lastBool == true && currentBool == true) {
        return true;
      }

      // If last value => end comparing
      if (versionListCopy.last == e) break;

      // Else set currentBool to lastBool
      lastBool = currentBool;
    }

    // Means inside [-infinity;version] or [version;infinity]
    if (lastBool == null && currentBool == true) return true;

    return false;
  }

  /// Return `true` if there is any satisfied version in sources
  ///
  /// ``` dart
  /// const versions = ['<100', '>=102'];
  /// print(SatisfiedVersion.listNumber(100, versions)); // => false
  /// print(SatisfiedVersion.listNumber(103, versions)); // => true
  /// print(SatisfiedVersion.listNumber(009, versions)); // => true
  /// ```
  ///
  /// Support value between 2 versions
  /// ``` dart
  /// const versionsInside = ['>100', '<150', '>=200', '<202'];
  /// print(SatisfiedVersion.listNumber(100, versionsInside)); // => false
  /// print(SatisfiedVersion.listNumber(103, versionsInside)); // => true
  /// print(SatisfiedVersion.listNumber(151, versionsInside)); // => false
  /// print(SatisfiedVersion.listNumber(201, versionsInside)); // => true
  /// print(SatisfiedVersion.listNumber(203, versionsInside)); // => false
  /// ```
  static bool listNumber(
    /// This is normally your current app version.
    int version,

    /// The version that has conditions to compare with `version`.
    List<String> versionList, {
    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    final List<String> versionListCopy = [...versionList];

    // Sort the versionList by it's version
    versionListCopy.sort((a, b) {
      final aComparator = int.parse(SatisfiedCondition.removeCondition(a));
      final bComparator = int.parse(SatisfiedCondition.removeCondition(b));
      return aComparator.compareTo(bComparator);
    });

    bool? lastBool;
    bool? currentBool;
    for (final e in versionListCopy) {
      final condition =
          SatisfiedCondition.parse(e, defaultCondition: defaultCondition);

      // If current condition is greater or greaterEqual then set `lastBool` to null.
      // Means we put the starting point here.
      if (condition
          case SatisfiedCondition.greater || SatisfiedCondition.greaterEqual) {
        lastBool = null;

        // If the first comparison version is greater than `version` => stop comparing
        if (!number(version, e, defaultCondition: defaultCondition)) {
          break;
        }
      }

      currentBool = number(version, e, defaultCondition: defaultCondition);

      // If both values are true, the current version is in the two conditions.
      if (lastBool == true && currentBool == true) {
        return true;
      }

      // If last value => end comparing
      if (versionListCopy.last == e) break;

      // Else set currentBool to lastBool
      lastBool = currentBool;
    }

    // Means inside [-infinity;version] or [version;infinity]
    if (lastBool == null && currentBool == true) return true;

    return false;
  }

  /// Return value of the satisfied key. Default is `false`
  ///
  /// `preferTrue` = true: Return `true` if it has at least 1 true condition
  /// `preferTrue` = false: Return `false` if it has at least 1 false condition. Default.
  ///
  /// ``` dart
  /// const versions = {'<1.0.0' : true, '>=1.0.2' : false};
  /// print(SatisfiedVersion.map('1.0.0', versions)); // => false
  /// print(SatisfiedVersion.map('1.0.3', versions)); // => false
  /// print(SatisfiedVersion.map('0.0.9', versions)); // => true
  /// ```
  static bool map(
    /// This is normally your current app version.
    String version,

    /// The version that has conditions to compare with `version`.
    Map<String, bool> versionMap, {
    /// [defaultValue] is the default result for `Map` when `version` is not in any range.
    bool defaultValue = false,

    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    final versionMapCopy = {...versionMap};

    // Sort the versionList by it's version
    versionMapCopy.entries.toList().sort((a, b) {
      final aComparator =
          Comparator(version: SatisfiedCondition.removeCondition(a.key));
      final bComparator =
          Comparator(version: SatisfiedCondition.removeCondition(b.key));
      return aComparator.compareTo(bComparator);
    });

    bool? result;

    // Compare from the biggest version, the first matched will be returned
    for (int i = versionMapCopy.length - 1; i >= 0; i--) {
      final compareWith = versionMapCopy.keys.elementAt(i);

      if (string(version, compareWith, defaultCondition: defaultCondition)) {
        result = versionMapCopy.values.elementAt(i);
      } else {
        if (result != null) return result;
      }
    }

    return result ?? defaultValue;
  }

  /// Return value of the satisfied key. Default is `false`.
  ///
  /// `defaultValue` is the default value if there is no version in range.
  ///
  /// `defaultCondition` is the default condition if there is no leading condition
  /// in this [versionMap].
  ///
  /// ``` dart
  /// const versions = {'<100' : true, '>=102' : false};
  /// print(SatisfiedVersion.map(100, versions)); // => false
  /// print(SatisfiedVersion.map(103, versions)); // => false
  /// print(SatisfiedVersion.map(99, versions)); // => true
  /// ```
  static bool mapNumber(
    /// This is normally your current app version.
    int version,

    /// The version that has conditions to compare with `version`.
    Map<String, bool> versionMap, {
    /// [defaultValue] is the default result for `Map` when `version` is not in any range.
    bool defaultValue = false,

    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    final versionMapCopy = {...versionMap};

    // Sort the versionList by it's version
    versionMapCopy.entries.toList().sort((a, b) {
      final aComparator = int.parse(SatisfiedCondition.removeCondition(a.key));
      final bComparator = int.parse(SatisfiedCondition.removeCondition(b.key));
      return aComparator.compareTo(bComparator);
    });

    bool? result;

    // Compare from the biggest version, the first matched will be returned
    for (int i = versionMapCopy.length - 1; i >= 0; i--) {
      final compareWith = versionMapCopy.keys.elementAt(i);

      if (number(version, compareWith, defaultCondition: defaultCondition)) {
        result = versionMapCopy.values.elementAt(i);
      } else {
        if (result != null) return result;
      }
    }

    return result ?? defaultValue;
  }
}
