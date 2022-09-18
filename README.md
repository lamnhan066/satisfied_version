# Satisfied Version

Check a version is satisfy with provided String, List, Map of versions or not.

## Usage

Compare 2 version with conditions:

``` dart
SatisfiedVersion.isSatisfied('1.0.0', '>=1.0.0') // => true
SatisfiedVersion.isSatisfied('1.0.0', '<=1.0.0') // => true

SatisfiedVersion.isSatisfied('1.0.0', '>1.0.0') // => false
SatisfiedVersion.isSatisfied('1.0.1', '>1.0.0') // => true
SatisfiedVersion.isSatisfied('1.0.0', '<1.0.0') // => false

SatisfiedVersion.isSatisfied('1.0.0', '=1.0.0') // => true
SatisfiedVersion.isSatisfied('1.0.0', '==1.0.0') // => true
// Default is return `appVersion == version`
```

Return `true` if there is any satisfied version in sources:

``` dart
const versions = ['<1.0.0', '>=1.0.2'];
print(SatisfiedVersion.list('1.0.0', versions)); // => false
print(SatisfiedVersion.list('1.0.3', versions)); // => true
print(SatisfiedVersion.list('0.0.9', versions)); // => true
```

Return value of the satisfied key. Default is `false`

- `preferTrue` = true: Return `true` if it has at least 1 true condition.
- `preferTrue` = false: Return `false` if it has at least 1 false condition. Default.

``` dart
const versions = {'<1.0.0' : true, '>=1.0.2' : false};
print(SatisfiedVersion.map('1.0.0', versions)); // => false
print(SatisfiedVersion.map('1.0.3', versions)); // => false
print(SatisfiedVersion.map('0.0.9', versions)); // => true
```

There is also a extension for String that help you easier to use this plugin:

``` dart
final result = '1.0.0'.isSatisfiedVersion('<=1.0.0'); // => true
final result = '1.0.0'.isSatisfiedVersion(['<=1.0.0']); // => true
final result = '1.0.0'.isSatisfiedVersion(['<=1.0.0' : false]); // => false
```
