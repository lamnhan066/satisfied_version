enum SatisfiedCondition {
  equal('=='),
  greaterEqual('>='),
  lessEqual('<='),
  equalSingle('='),
  greater('>'),
  less('<');

  final String asString;

  const SatisfiedCondition(this.asString);

  static bool isStartWithCondition(String version) {
    for (final condition in values) {
      if (version.startsWith(condition.asString)) return true;
    }

    return false;
  }

  static SatisfiedCondition parse(
    String version, {
    SatisfiedCondition defaultCondition = SatisfiedCondition.equal,
  }) {
    for (final condition in values) {
      if (version.startsWith(condition.asString)) return condition;
    }

    return defaultCondition;
  }

  static String removeCondition(String version) {
    final condition = parse(
      version,
      defaultCondition: SatisfiedCondition.equal,
    );
    if (version.startsWith(condition.asString)) {
      return version.substring(condition.asString.length);
    }
    return version;
  }
}
