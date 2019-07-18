![](https://github.com/pedrommcarrasco/Hover/blob/master/Design/logo.png?raw=true)

<p align="center">
<img src="https://github.com/pedrommcarrasco/Hover/blob/master/Design/demo.gif?raw=true" alt="Presentation" width="100%"/>
</p>

# 🎈 What's Hover?

> **Hover** *(/ˈhɒv.ər/)*, *verb*
>
> "to stay in one place in the air"

Hover is a draggable **floating action button** (FAB) inspired by Apple's session [**Designing Fluid Interfaces**](https://developer.apple.com/wwdc18/803) & Nathan Gitter's [fluid-interfaces](https://github.com/nathangitter/fluid-interfaces). Hover will always stick to the nearest corner to avoid blocking content and allows the user to send it to any other corner with a single swipe.

[![CocoaPods](https://img.shields.io/cocoapods/v/Hover.svg)](https://cocoapods.org/pods/Hover)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![apm](https://img.shields.io/apm/l/vim-mode.svg)](https://github.com/pedrommcarrasco/Hover/blob/master/LICENSE)

# 📦 Installation

## CocoaPods
Add the following line to your `podfile`:

```swift
pod 'Hover'
```
And then run the following command in terminal:

```swift
pod install
```

## Carthage
Add the following line to your `cartfile`:

```swift
github "pedrommcarrasco/Hover"
```

And then run the following command in terminal:

```swift
carthage update
```

# ⌨️ Usage Example
After installing **Hover**, you should start by importing the framework:

```swift
import Hover
```

Once imported, you can start using **Hover** like follows:

```swift
// Create Hover's Configuration (all parameters have defaults)
let configuration = HoverConfiguration(icon: UIImage(named: "add"), color: .gradient(top: .blue, bottom: .cyan))

// Create the items to display
let items = [
    HoverItem(title: "Drop it Anywhere", image: UIImage(named: "anywhere")) { print("Tapped 'Drop it anywhere'") },
    HoverItem(title: "Gesture Driven", image: UIImage(named: "gesture")) { print("Tapped 'Gesture driven'") },
    HoverItem(title: "Give it a Star", image: UIImage(named: "star")) { print("Tapped 'Give it a star'") }
]

// Create an HoverView with the previous configuration & items
let hoverView = HoverView(with: configuration, items: items)

// Add to the top of the view hierarchy
view.addSubview(hoverView)
hoverView.translatesAutoresizingMaskIntoConstraints = false

// Apply Constraints
// Never constrain to the safe area as Hover takes care of that
NSLayoutConstraint.activate(
    [
        hoverView.topAnchor.constraint(equalTo: view.topAnchor),
        hoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        hoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        hoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ]
)
```

For more details about all the parameters that you can configure, take a look into [`HoverConfiguration.swift`](https://github.com/pedrommcarrasco/Hover/blob/master/Hover/Model/HoverConfiguration.swift).

# 📲 Sample Project
There's a sample project in this repository with some samples of Hover called [Example](https://github.com/pedrommcarrasco/Hover/tree/master/Example).

# 🙌 Contributing
Feel free to contribute to this project by [reporting bugs](https://github.com/pedrommcarrasco/Hover/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc) or open [pull requests](https://github.com/pedrommcarrasco/Hover/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-desc).

Hover was created for personal use but dynamic enough to be an open-source framework. As such, while functional, it may lack some additional customization. If there's something missing that you need, feel free to ask me here or on [Twitter](https://twitter.com/pedrommcarrasco).

# ⛔ License
Constrictor's available under the MIT license. See the [LICENSE](https://github.com/pedrommcarrasco/Hover/blob/master/LICENSE) file for more information.
