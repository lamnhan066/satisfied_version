# Satisfied Version

Check whether the version is satisfied with provided String, List, or Map of versions or not.

## **Usage**

### **String:** Compare 2 version with conditions

``` dart
SatisfiedVersion.string('1.0.0', '>=1.0.0') // => true
SatisfiedVersion.string('1.0.0', '<=1.0.0') // => true

SatisfiedVersion.string('1.0.0', '>1.0.0') // => false
SatisfiedVersion.string('1.0.1', '>1.0.0') // => true
SatisfiedVersion.string('1.0.0', '<1.0.0') // => false

SatisfiedVersion.string('1.0.0', '=1.0.0') // => true
SatisfiedVersion.string('1.0.0', '==1.0.0') // => true
// Default is return `appVersion == version`
```

### **List:** Return `true` if there is any satisfied version in sources

``` dart
const versions = ['<1.0.0', '>=1.0.2'];
print(SatisfiedVersion.list('1.0.0', versions)); // => false
print(SatisfiedVersion.list('1.0.3', versions)); // => true
print(SatisfiedVersion.list('0.0.9', versions)); // => true
```

You can also compare the version within the range:

``` dart
// You can input a shuffled list of values, the plugin will sort it for you.
// But I recommend you to sort it yourself to make it easier to maintain.
const versionsWithin = ['>1.0.0', '<1.5.0', '1.6.0', '>=2.0.0', '<2.0.2'];
print(SatisfiedVersion.list('1.0.0', versionsWithin); // => false
print(SatisfiedVersion.list('1.1.0', versionsWithin); // => true
print(SatisfiedVersion.list('1.5.1', versionsWithin); // => false
print(SatisfiedVersion.list('1.6.0', versionsWithin); // => true
print(SatisfiedVersion.list('2.0.1', versionsWithin); // => true
print(SatisfiedVersion.list('2.0.2', versionsWithin); // => false
```

### **Map:** Return value of the satisfied key. Default is `false`

- `preferTrue` = `true`: Return `true` if it has at least 1 true condition.
- `preferTrue` = `false`: Return `false` if it has at least 1 false condition. Default.

``` dart
const versions = {'<1.0.0' : true, '>=1.0.2' : false};
print(SatisfiedVersion.map('1.0.0', versions)); // => false
print(SatisfiedVersion.map('1.0.3', versions)); // => false
print(SatisfiedVersion.map('0.0.9', versions)); // => true
```

### **Extension:** There is also a extension for String that help you easier to use this plugin

``` dart
final result = '1.0.0'.satisfiedWith('<=1.0.0'); // => true
final result = '1.0.0'.satisfiedWith(['<=1.0.0', '>2.0.0']); // => true
final result = '1.0.0'.satisfiedWith(['<=1.0.0' : false]); // => false
```

## **Additional Parameters**

- For all:
  - `defaultCondition` is the default condition if the compared version is provided without condition. Default value is `SatisfiedCondition.equal`.
  
- For specific `Map`:
  - `defaultValue` is the default result for `Map` when `appVersion` is not in any range.
  - `preferTrue` is the preferred value when there are multiple results in `Map`.
