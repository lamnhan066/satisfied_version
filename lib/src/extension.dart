import 'satisfied_version.dart';
import 'satisfiled_condition.dart';

extension SatisfiedVersionEx on String {
  /// Extension for the below methods with auto recognition:
  ///   [SatisfiedVersion.string]
  ///   [SatisfiedVersion.list]
  ///   [SatisfiedVersion.map]
  bool satisfiedWith(
    /// [compareWith] only supports `String`, `List<String>` and `Map<String, bool>`.
    ///
    /// '>=1.0.0'; ['>=1.0.0', '<=2.0.0']; {'>=1.0.0': true, '<=2.0.0': true}
    dynamic compareWith, {
    /// [defaultValue] is the default result for `Map` when `appVersion` is not in any range.
    bool defaultValue = false,

    /// [preferTrue] is the preferred value when there are multiple results in `Map`.
    bool preferTrue = false,

    /// [defaultCondition] is the default condition if the compared version is provided without condition.
    ///
    /// `'1.0.0'.satisfiedWith('1.0.0') = '1.0.0'.satisfiedWith('==1.0.0') => true`
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

    return throw UnsupportedError(
        'This method only support `String`, `List<String>` and `Map<String, bool`');
  }
}
