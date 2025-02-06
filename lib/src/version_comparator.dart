class VersionComparator implements Comparable<VersionComparator> {
  /// Version with format "major.minor.patch".
  final String version;

  /// Detail of the version.
  late final (int major, int minor, int patch) detail;

  /// A comparator to compare 2 versions with format "major.minor.patch".
  VersionComparator(this.version) {
    detail = _splitVersion();
  }

  /// Split the version into 3 numbers.
  ///
  /// Throws a FormatException if the version format is not "major.minor.patch" with valid non-negative integers.
  (int major, int minor, int patch) _splitVersion() {
    final regExp = RegExp(r'^(\d+)\.(\d+)\.(\d+)$');
    final match = regExp.firstMatch(version);

    if (match == null) {
      throw FormatException(
        'Invalid version format. Expected "major.minor.patch", but found: $version',
      );
    }

    final major = int.parse(match.group(1)!);
    final minor = int.parse(match.group(2)!);
    final patch = int.parse(match.group(3)!);

    if (major < 0 || minor < 0 || patch < 0) {
      throw FormatException(
        'Version numbers must be positive or zero. Found: $version',
      );
    }

    return (major, minor, patch);
  }

  bool operator >(VersionComparator other) {
    final isGreaterMajor = detail.$1 > other.detail.$1;
    final isGreaterMinor =
        detail.$1 == other.detail.$1 && detail.$2 > other.detail.$2;
    final isGreaterPatch = detail.$1 == other.detail.$1 &&
        detail.$2 == other.detail.$2 &&
        detail.$3 > other.detail.$3;

    if (isGreaterMajor || isGreaterMinor || isGreaterPatch) {
      return true;
    }

    return false;
  }

  bool operator >=(VersionComparator other) {
    if (this == other) return true;
    return this > other;
  }

  bool operator <(VersionComparator other) {
    final isLessMajor = detail.$1 < other.detail.$1;
    final isLessMinor =
        detail.$1 == other.detail.$1 && detail.$2 < other.detail.$2;
    final isLessPatch = detail.$1 == other.detail.$1 &&
        detail.$2 == other.detail.$2 &&
        detail.$3 < other.detail.$3;

    if (isLessMajor || isLessMinor || isLessPatch) {
      return true;
    }

    return false;
  }

  bool operator <=(VersionComparator other) {
    if (this == other) return true;
    return this < other;
  }

  @override
  int compareTo(VersionComparator other) {
    if (this > other) return 1;
    if (this < other) return -1;

    return 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VersionComparator && hashCode == other.hashCode;
  }

  @override
  int get hashCode =>
      detail.$1.hashCode ^ detail.$2.hashCode ^ detail.$3.hashCode;
}
