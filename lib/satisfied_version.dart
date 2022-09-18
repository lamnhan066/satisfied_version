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
    /// [version] only supports `String`, `List<String>` and `Map<String, bool>`
    dynamic version, {

    /// [defaultValue] is the default result for `List` and `Map`
    bool defaultValue = false,

    /// [preferTrue] is the priority value when multiple results are available
    bool preferTrue = false,

    /// [defaultCondition] is the default condition if 2 version is provided without condition
    ///
    /// `'1.0.0'.isSatisfiedVersion('1.0.0') = '1.0.0'.isSatisfiedVersion('==1.0.0') => true`
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    if (version is String) {
      return SatisfiedVersion.isSatisfied(
        this,
        version,
        defaultCondition: defaultCondition,
      );
    }

    if (version is List) {
      return SatisfiedVersion.list(
        this,
        version as List<String>,
        defaultCondition: defaultCondition,
      );
    }

    if (version is Map) {
      return SatisfiedVersion.map(
        this,
        version as Map<String, bool>,
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
    String appVersion,
    String version, {
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    appVersion = appVersion.trim();
    version = version.trim();

    if (version.startsWith(SatisfiedCondition.greaterEqual.asString)) {
      return appVersion.compareTo(version.substring(2).trim()) >= 0;
    }

    if (version.startsWith(SatisfiedCondition.lessEqual.asString)) {
      return appVersion.compareTo(version.substring(2).trim()) <= 0;
    }

    if (version.startsWith(SatisfiedCondition.equal.asString)) {
      return appVersion.compareTo(version.substring(2).trim()) == 0;
    }

    if (version.startsWith(SatisfiedCondition.greater.asString)) {
      return appVersion.compareTo(version.substring(1).trim()) > 0;
    }

    if (version.startsWith(SatisfiedCondition.less.asString)) {
      return appVersion.compareTo(version.substring(1).trim()) < 0;
    }

    if (version.startsWith(SatisfiedCondition.equalSingle.asString)) {
      return appVersion.compareTo(version.substring(1).trim()) == 0;
    }

    return isSatisfied(appVersion, '${defaultCondition.asString}$version');
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
    String appVersion,
    List<String> versions, {
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    for (final e in versions) {
      if (isSatisfied(
        appVersion,
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
    String appVersion,
    Map<String, bool> sources, {
    bool preferTrue = false,
    bool defaultValue = false,
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    bool? result;
    for (final e in sources.keys) {
      if (isSatisfied(
        appVersion,
        e,
        defaultCondition: defaultCondition,
      )) {
        result = sources[e]!;

        if (result == preferTrue) return result;
      }
    }

    return result ?? defaultValue;
  }
}
