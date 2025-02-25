## 0.4.2

* Add the different (!=) comparator.
* Throw a `FormatException` if the version format is not "major.minor.patch" with valid non-negative integers.
* Trim the inputted version before parsing.
* Correct the typo: "conparator" -> "comparator".
* Improve the parser to treat `001.02.0003` as `1.2.3`.
* Export the `VersionComparator`.
* Add more test cases.
* Add a basic example and an URL in README to try it.

## 0.4.1

* Update homepage URL.
* Update comments.
* Fix README typo.
* Fix CHANGELOG typo.

## 0.4.0

* Add supports for build number (compare 2 integers).
* Add `createString` and `createNumber` as helpers to create a version in `String` and `int` with leading condition.
* Rename from `satisfiedWith` to `satisfysWith` (`satisfiedWith` will be marked as deprecated).
* **BREAKING CHANGE**
  * Remove `preferTrue` in `Map`, the biggest version value will be used if there is many satisfied version ranges.

## 0.3.0

* Bump sdk to ">=3.0.0 <4.0.0".
* Better support for the version with format "major.minor.patch".
* Remove deprecated function: `.isSatisfiedVersion`, `SatisfiedVersion.isSatisfied`.
* Improve test and cover up to 100%.

## 0.2.0

* Bump sdk to ">=2.18.0 <4.0.0".

## 0.1.0+2

* Improved pub score.

## 0.1.0+1

* Improved README.

## 0.1.0

* [BUG] add `defaultCondition` to `_getCondition` (Internal).
* [DEPRECATED] change extension from `isSatisfiedVersion` to `satisfiedWith`.
* [DEPRECATED] change from `SatisfiedVersion.isSatisfied` to `SatisfiedVersion.string`.
* Improve test for extension.

## 0.0.2

* Added support to compare the version within the range for `List`. See README.

## 0.0.1+3

* Supports dart native.

## 0.0.1+2

* README typo.
* Removed useless dependencies to support dart native.

## 0.0.1+1

* Initial release.
