# SUISideMenu
[![License](https://img.shields.io/cocoapods/l/SideMenu.svg?style=flat-square)](http://cocoapods.org/pods/SideMenu)
[![Platform](https://img.shields.io/cocoapods/p/SideMenu.svg?style=flat-square)](http://cocoapods.org/pods/SideMenu)

### If you like SUISideMenu, give it a ★ at the top right of this page.


* **[Overview](#overview)**
  * [Preview Samples](#preview-samples) 
* **[Requirements](#requirements)**
* **[Installation](#installation)**
  * [CocoaPods](#cocoapods)
* **[Usage](#usage)**
  * [Code Implementation](#code-implementation)
* [Author](#author)
* [Credits](#credits)
* [License](#license)

## Overview

SUISideMenu is Simple Side menu solution for those who want a simple and elegant solution. It is write with/for SwiftUI.
- [x] Changeable MenuWidth, Blur, Scale and background dimming.
- [x] Two Menu Style slideInOver and slideInOut
- [x] Highly customizable without needing to write tons of custom code.
- [x] handles screen rotation.
- [x] Written with SwiftUI.

Check out the example project to see it in action!
### Preview Samples
| slideInOver | slideInOut | 
| --- | --- | 
| ![](https://github.com/ezzmoaz/SUISideMenu/blob/master/Assests/slideInOver.gif) | ![](https://github.com/ezzmoaz/SUISideMenu/blob/master/Assests/slideInOut.gif) |

## Requirements
- [x] Xcode 11 or higher.
- [x] Swift 5 or higher.
- [x] iOS 13 or higher.



## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SideMenu into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SUISideMenu'
```

Then, run the following command:

```bash
$ pod install
```



## Usage
### Code Implementation
First:
```swift
import SUISideMenu
```

Please make sure to add the following environmentObject preferred in the SceneDelegte or as the examples below
```swift
.environmentObject(UIStateModel())
```


Then in the Body of the very first View use it as follow:
```swift
var body: some View {
        SideMenu(sideMenu: {
            //HERE:- Put The View you want to use as SideMenu
            //Example:
            Text("SideMenu")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
        }, mainView: {
            //HERE:- Put The View you want to use as Main View
            //Example:
            Text("mainView")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
        }).environmentObject(UIStateModel()) //Very Important
    }
```

You Can Customize the sideMenu as Follow
```swift
            SideMenu(menuWidth: 0.6, // <= 1
                     menuStyle: .slideInOver,// .slideInOver || .slideInOut
                     blur: 2,
                     scale: 1, // <= 1
                     dimValue: 0.2, // <= 1
                     sideMenu: {
                        //HERE:- Put The View you want to use as SideMenu
                        //Example:
                        Text("SideMenu")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.red)
            }, mainView: {
                //HERE:- Put The View you want to use as SideMenu
                //Example:
                Text("mainView")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
            }).environmentObject(UIStateModel()) //Very Important
```

## Credits
Inspired by this article

[https://medium.com/flawless-app-stories/implementing-snap-carousel-in-swiftui-3ae084504670](https://medium.com/flawless-app-stories/implementing-snap-carousel-in-swiftui-3ae084504670)

## Author

Moazezz, moazezz@icloud.com

## License

SUISideMenu is available under the MIT license. See the LICENSE file for more info.
