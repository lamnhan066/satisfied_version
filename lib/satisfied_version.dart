enum SatisfiedCondition {
  equal('=='),
  equalSingle('='),
  greater('>'),
  greaterEqual('>='),
  less('<'),
  lessEqual('<=');

  final String asString;

  const SatisfiedCondition(this.asString);
}

extension SatisfiedVersionEx on String {
  /// Extension for the below methods with auto recognition:
  ///   `SatisfiedVersion.isSatisfied`
  ///   `SatisfiedVersion.list`
  ///   `SatisfiedVersion.map`
  bool isSatisfiedVersion(
    /// [compareWith] only supports `String`, `List<String>` and `Map<String, bool>`.
    dynamic compareWith, {

    /// [defaultValue] is the default result for `Map` when `appVersion` is not in any range.
    bool defaultValue = false,

    /// [preferTrue] is the preferred value when there are multiple results in `Map`.
    bool preferTrue = false,

    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    ///
    /// `'1.0.0'.isSatisfiedVersion('1.0.0') = '1.0.0'.isSatisfiedVersion('==1.0.0') => true`
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    if (compareWith is String) {
      return SatisfiedVersion.isSatisfied(
        this,
        compareWith,
        defaultCondition: defaultCondition,
      );
    }

    if (compareWith is List) {
      return SatisfiedVersion.list(
        this,
        compareWith as List<String>,
        defaultCondition: defaultCondition,
      );
    }

    if (compareWith is Map) {
      return SatisfiedVersion.map(
        this,
        compareWith as Map<String, bool>,
        defaultValue: defaultValue,
        defaultCondition: defaultCondition,
        preferTrue: preferTrue,
      );
    }

    throw UnsupportedError(
        'This method only support `String`, `List<String>` and `Map<String, bool`');
  }
}

class SatisfiedVersion {
  /// Prevent creating new instances
  SatisfiedVersion._();

  /// Compare 2 version with conditions
  ///
  /// `isSatisfied('1.0.0', '>=1.0.0')` => true
  /// `isSatisfied('1.0.0', '<=1.0.0')` => true
  ///
  /// `isSatisfied('1.0.0', '>1.0.0')` => false
  /// `isSatisfied('1.0.1', '>1.0.0')` => true
  /// `isSatisfied('1.0.0', '<1.0.0')` => false
  ///
  /// `isSatisfied('1.0.0', '=1.0.0')` => true
  /// `isSatisfied('1.0.0', '==1.0.0')` => true
  ///
  /// Default is return `appVersion == version`
  static bool isSatisfied(
    /// This is normally your current app version.
    String version,

    /// The version that has conditions to compare with `version`.
    String compareWith, {

    /// Default condition if `compareWith` doesn't have the condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    version = version.trim();
    compareWith = compareWith.trim();

    if (compareWith.startsWith(SatisfiedCondition.greaterEqual.asString)) {
      return version.compareTo(compareWith.substring(2).trim()) >= 0;
    }

    if (compareWith.startsWith(SatisfiedCondition.lessEqual.asString)) {
      return version.compareTo(compareWith.substring(2).trim()) <= 0;
    }

    if (compareWith.startsWith(SatisfiedCondition.equal.asString)) {
      return version.compareTo(compareWith.substring(2).trim()) == 0;
    }

    if (compareWith.startsWith(SatisfiedCondition.greater.asString)) {
      return version.compareTo(compareWith.substring(1).trim()) > 0;
    }

    if (compareWith.startsWith(SatisfiedCondition.less.asString)) {
      return version.compareTo(compareWith.substring(1).trim()) < 0;
    }

    if (compareWith.startsWith(SatisfiedCondition.equalSingle.asString)) {
      return version.compareTo(compareWith.substring(1).trim()) == 0;
    }

    return isSatisfied(version, '${defaultCondition.asString}$compareWith');
  }

  /// Return `true` if there is any satisfied version in sources
  ///
  /// ``` dart
  /// const versions = ['<1.0.0', '>=1.0.2'];
  /// print(SatisfiedVersion.list('1.0.0', versions)); // => false
  /// print(SatisfiedVersion.list('1.0.3', versions)); // => true
  /// print(SatisfiedVersion.list('0.0.9', versions)); // => true
  /// ```
  static bool list(
    /// This is normally your current app version.
    String version,

    /// The version that has conditions to compare with `version`.
    List<String> versionList, {

    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    for (final e in versionList) {
      if (isSatisfied(
        version,
        e,
        defaultCondition: defaultCondition,
      )) {
        return true;
      }
    }

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

    /// [preferTrue] is the preferred value when there are multiple results.
    bool preferTrue = false,

    /// [defaultValue] is the default result for `Map` when `version` is not in any range.
    bool defaultValue = false,

    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    bool? result;
    for (final e in versionMap.keys) {
      if (isSatisfied(
        version,
        e,
        defaultCondition: defaultCondition,
      )) {
        result = versionMap[e]!;

        if (result == preferTrue) return result;
      }
    }

    return result ?? defaultValue;
  }
}
