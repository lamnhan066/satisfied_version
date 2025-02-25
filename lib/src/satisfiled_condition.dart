enum SatisfiedCondition {
  /// !=.
  different('!='),

  /// ==.
  equal('=='),

  /// >=.
  greaterEqual('>='),

  /// <=.
  lessEqual('<='),

  /// =.
  equalSingle('='),

  /// >.
  greater('>'),

  /// <.
  less('<');

  /// Return this condition in String (>,<,>=,<=,==,=).
  final String asString;

  /// Constuctor of the condition.
  const SatisfiedCondition(this.asString);

  /// Check if a String starts with condition.
  static bool isStartWithCondition(String version) {
    version = version.trim();
    for (final condition in values) {
      if (version.startsWith(condition.asString)) return true;
    }

    return false;
  }

  /// Parse this [version] to [SatisfiedCondition].
  static SatisfiedCondition parse(
    String version, {
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    version = version.trim();
    for (final condition in values) {
      if (version.startsWith(condition.asString)) return condition;
    }

    return defaultCondition;
  }

  /// Remove condition from this [version].
  static String removeCondition(String version) {
    version = version.trim();
    final condition = parse(
      version,
      defaultCondition: SatisfiedCondition.equal,
    ).asString;
    if (version.startsWith(condition)) {
      return version.substring(condition.length);
    }
    return version;
  }
}
