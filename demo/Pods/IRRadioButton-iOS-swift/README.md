![Build Status](https://img.shields.io/badge/build-%20passing%20-brightgreen.svg)
![Platform](https://img.shields.io/badge/Platform-%20iOS%20-blue.svg)

# IRRadioButton-iOS-swift

- IRRadioButton-iOS-swift is a powerful radio button for iOS.
- Pretty simple class that extends standard UIButton functionality. Default and selected states can be configured for every button.

## Features
- Radio buttons

## Install
### Git
- Git clone this project.
- Copy this project into your own project.
- Add the .xcodeproj into you  project and link it as embed framework.
#### Options
- You can remove the `demo` and `ScreenShots` folder.

### Cocoapods
- Add `pod 'IRRadioButton-iOS-swift'`  in the `Podfile`
- `pod install`

## Usage

### Basic
It does not need any central manager. Just link the buttons right in Interface Builder, ex:Button A link with B and C:
![Interface Builder ](./ScreenShots/demo1.png)

Alternatively group the buttons using single line of code:

```swift
radio1.groupButtons = [radio1, radio2, radio3]
```

Select any button, and all other button in the same group become deselected automatically:

```swift
radio2.setSelected(true)  // radio1 and radio3 become deselected
```

And a helpful method to select button by tag:

```swift
radio1.setSelectedWithTag(kTagRadio3)
```

## Screenshots
![Demo](./ScreenShots/demo2.png)

## Copyright
##### This project is inspired from [RadioButton-iOS](https://github.com/onegray/RadioButton-ios).

