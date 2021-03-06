# NSUserDefaultsOverride

Override user defaults for testing.

## How to use?

Just add `NSUserDefaults+Override.h` and `NSUserDefaults+Override.m` to your Xcode project. I recommend only adding it to the test target.

If you are using Swift, add `#import "NSUserDefaults+Override.h"` to the bridging header.

### Objective C Example

```Obj-C
NSLog(@"%d", [[NSUserDefaults standardUserDefaults] boolForKey:@"DoesItWork?"]); // outputs 0
[[NSUserDefaults standardUserDefaults] overrideValue:@(YES) forKey:@"DoesItWork?"];
NSLog(@"%d", [[NSUserDefaults standardUserDefaults] boolForKey:@"DoesItWork?"]); // outputs 1
```
### Swift Example

```swift
print(UserDefaults.standard.bool(forKey: "ExampleKey")) // outputs false
UserDefaults.standard.overrideValue(true, forKey: "ExampleKey")
print(UserDefaults.standard.bool(forKey: "ExampleKey")) // outputs true
```

## What is this good for?

It's hard to write unit tests for features that change according to user preferences.

You want to test all cases, so you need to change user defaults before running a test.

But if you change NSUserDefaults, other processes running at the same time will also be affected, and the changes will be written to disk. You need to remember to restore settings after the test completes, and hope that your test never crashes. And you can never run two tests at the same time.

So this is a way to override the values returned by NSUserDefaults temporarily.

## How does it work?

It uses method swizzling to replace the standard implementations of `objectForKey:` etc.

## Why use this instead of some other method?

- You can continue to use NSUserDefaults in your code normally
- No modifications to your app necessary (modifications only happen while testing)
- Overrides are never persisted to disk and don't influence other processes

## What's missing?

- Does not send KVO notifications when a key is overridden

## License

I've released this code under the MIT license. If you need a different license, let me know!
