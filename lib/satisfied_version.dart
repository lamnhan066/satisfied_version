enum SatisfiedCondition {
  equal('=='),
  greaterEqual('>='),
  lessEqual('<='),
  equalSingle('='),
  greater('>'),
  less('<');

  final String asString;

  const SatisfiedCondition(this.asString);
}

extension SatisfiedVersionEx on String {
  /// Extension for the below methods with auto recognition:
  ///   [SatisfiedVersion.string]
  ///   [SatisfiedVersion.list]
  ///   [SatisfiedVersion.map]
  @Deprecated('Use `satisfiedWith` instead')
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
  }) =>
      satisfiedWith(
        compareWith,
        defaultValue: defaultValue,
        preferTrue: preferTrue,
        defaultCondition: defaultCondition,
      );

  /// Extension for the below methods with auto recognition:
  ///   [SatisfiedVersion.string]
  ///   [SatisfiedVersion.list]
  ///   [SatisfiedVersion.map]
  bool satisfiedWith(
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
      return SatisfiedVersion.string(
        this,
        compareWith,
        defaultCondition: defaultCondition,
      );
    }

    if (compareWith is List<String>) {
      return SatisfiedVersion.list(
        this,
        compareWith,
        defaultCondition: defaultCondition,
      );
    }

    if (compareWith is Map<String, bool>) {
      return SatisfiedVersion.map(
        this,
        compareWith,
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
  @Deprecated('Use `string` instead')
  static bool isSatisfied(
    /// This is normally your current app version.
    String version,

    /// The version that has conditions to compare with `version`.
    String compareWith, {

    /// Default condition if `compareWith` doesn't have the condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) =>
      string(version, compareWith, defaultCondition: defaultCondition);

  ///   Compare 2 version with conditions
  ///
  /// `satisfiedString('1.0.0', '>=1.0.0')` => true
  /// `satisfiedString('1.0.0', '<=1.0.0')` => true
  ///
  /// `satisfiedString('1.0.0', '>1.0.0')` => false
  /// `satisfiedString('1.0.1', '>1.0.0')` => true
  /// `satisfiedString('1.0.0', '<1.0.0')` => false
  ///
  /// `satisfiedString('1.0.0', '=1.0.0')` => true
  /// `satisfiedString('1.0.0', '==1.0.0')` => true
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

    return string(version, '${defaultCondition.asString}$compareWith');
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
    versionListCopy
        .sort((a, b) => _removeCondition(a).compareTo(_removeCondition(b)));

    bool? lastBool;
    bool? currentBool;
    for (final e in versionListCopy) {
      // If current condition is greater or greaterEqual then set `lastBool` to null.
      // Means we put the starting point here.
      if ([SatisfiedCondition.greater, SatisfiedCondition.greaterEqual]
          .contains(_getCondition(e, defaultCondition: defaultCondition))) {
        lastBool = null;

        // If the first comparison version is greater than `version` => stop comparing
        if (!string(version, e)) break;
      }
      currentBool = string(
        version,
        e,
        defaultCondition: defaultCondition,
      );

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

    /// [preferTrue] is the preferred value when there are multiple results.
    bool preferTrue = false,

    /// [defaultValue] is the default result for `Map` when `version` is not in any range.
    bool defaultValue = false,

    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    bool? result;
    for (final e in versionMap.keys) {
      if (string(
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

  static SatisfiedCondition _getCondition(
    String version, {
    required SatisfiedCondition defaultCondition,
  }) {
    for (final condition in SatisfiedCondition.values) {
      if (version.startsWith(condition.asString)) return condition;
    }
    return defaultCondition;
  }

  static String _removeCondition(String version) {
    final condition =
        _getCondition(version, defaultCondition: SatisfiedCondition.equal);
    if (version.startsWith(condition.asString)) {
      return version.substring(condition.asString.length);
    }
    return version;
  }
}
