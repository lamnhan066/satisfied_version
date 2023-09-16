class Comparator {
  /// Version with format "major.minor.patch"
  final String version;

  /// Detail of the version
  late final (int major, int minor, int patch)? detail;

  /// A comparator to compare 2 versions with format "major.minor.patch"
  Comparator({
    required this.version,
  }) {
    detail = _splitVersion();
  }

  /// Split the version into 3 number
  ///
  /// Returns `null` when there is error when splitting
  (int major, int minor, int patch)? _splitVersion() {
    final splitted = version.split('.');
    final major = int.tryParse(splitted[0]);
    final minor = int.tryParse(splitted[1]);
    final patch = int.tryParse(splitted[2]);

    final isError = major == null || minor == null || patch == null;
    if (isError) {
      return null;
    }
    return (major, minor, patch);
  }

  /// this > other
  bool isGreater(Comparator other) {
    if (detail == null || other.detail == null) {
      return false;
    }

    final isGreaterMajor = detail!.$1 > other.detail!.$1;
    final isGreaterMinor =
        detail!.$1 == other.detail!.$1 && detail!.$2 > other.detail!.$2;
    final isGreaterPatch = detail!.$1 == other.detail!.$1 &&
        detail!.$2 == other.detail!.$2 &&
        detail!.$3 > other.detail!.$3;

    if (isGreaterMajor || isGreaterMinor || isGreaterPatch) {
      return true;
    }

    return false;
  }

  /// this >= other
  bool isGreaterEqual(Comparator other) {
    if (this == other) return true;
    return isGreater(other);
  }

  /// this < other
  bool isLess(Comparator other) {
    if (detail == null || other.detail == null) {
      return false;
    }

    final isLessMajor = detail!.$1 < other.detail!.$1;
    final isLessMinor =
        detail!.$1 == other.detail!.$1 && detail!.$2 < other.detail!.$2;
    final isLessPatch = detail!.$1 == other.detail!.$1 &&
        detail!.$2 == other.detail!.$2 &&
        detail!.$3 < other.detail!.$3;

    if (isLessMajor || isLessMinor || isLessPatch) {
      return true;
    }

    return false;
  }

  /// this <= other
  bool isLessEqual(Comparator other) {
    if (this == other) return true;
    return isLess(other);
  }

  int compareTo(Comparator other) {
    if (isGreater(other)) return 1;
    if (isLess(other)) return -1;

    return 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comparator && hashCode == other.hashCode;
  }

  @override
  int get hashCode => version.hashCode;
}
