<p align="center">
    <img src="logo.gif?raw=true alt="SliceControl" width="100%"/>
</p>
                      
> **Slice** *(/slɑɪs/)*, *noun*
>
> "A slice is any small part that has been separated from something larger"

[![CocoaPods](https://img.shields.io/cocoapods/v/SliceControl.svg)](https://cocoapods.org/pods/SliceControl)
[![apm](https://img.shields.io/apm/l/vim-mode.svg)](https://github.com/pedrommcarrasco/SliceControl/blob/master/LICENSE)

# Usage Example ⌨️

After installing **SliceControl**, you should start by importing the framework:

```swift
import SliceControl
```

Once imported, you can start using **SliceControl** like follows:

```swift
sliceControl = SliceControl(with: ["All", "Liked", "Favourited"],
                            primaryColor: .darkGray,
                            secondaryColor: .white,
                            padding: 12)

// Implement SliceControlDelegate to intercept actions
sliceControl.delegate = self

view.addSubview(sliceControl)
// ... Constrain it
```
You can also set its `UIFont` and starting option.

## RxSwift
Would you like to subscribe to SliceControl's events using RxSwift? **[RxSliceControl](https://github.com/pedrommcarrasco/RxSliceControl)** is here to save you!

# Instalation 📦

**SliceControl** is available through [CocoaPods](https://cocoapods.org/pods/SliceControl). In order to install, add the following line to your Podfile:

```swift
pod 'SliceControl'
```
And run the following command in terminal:

```swift
pod install
```

# Sample Project  📲

There's a sample project in this repository called [Example](https://github.com/pedrommcarrasco/SliceControl/tree/master/Example).

# Contributing  🙌 

Feel free to contribute to this project by providing [ideas](https://github.com/pedrommcarrasco/SliceControl/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc) or opening [pull requests](https://github.com/pedrommcarrasco/SliceControl/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-desc).

# License ⛔

SliceControl's available under the MIT license. See the [LICENSE](https://github.com/pedrommcarrasco/SliceControl/blob/master/LICENSE) file for more information.
