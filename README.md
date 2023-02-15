# PopUpSwift

 [![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Beautiful `PopUpView` that supports portrait and landscape orientation, with flexible view settings.

## Gifs
![](./demo.gif)

## Screenshots
![](./demo.png)

## Installation
### [Swift Package Manager](https://swift.org/package-manager/)

Going to Xcode `File` > `Add Packages...` and add the repository by giving the URL of this GitHub.

## Usage

 ```swift
 import PopUpSwift
 ```
 
 ```swift
let singleLineExampleText = "Life is like a box of chocolates, you never know what you’re gonna get."

let multiLineExampleText = """
Life is like a box of
chocolates,
you never know what you’re gonna
get.
"""

// Create any view or use ready-made shapes.
let image = Image("BrooklynBridge")
    .resizable()
    .aspectRatio(contentMode: .fill)
    .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.white, lineWidth: 0.9)
    )
    .frame(width: 60, height: 60)

// PopUp with light style (default).
PopUpView(
    shape: .circle,
    shapeColor: .mint,
    text: singleLineExampleText
) {
    print("Do something on tapped on the popup.")
}

// PopUp with custom style.
PopUpView(
    anyView: AnyView(image),
    text: multiLineExampleText,
    popUpType: .bottom
)
.popUpStyle(
    .customPopUpStyle(
        textColor: .white,
        backgroundColor: .secondary
    )
)

// PopUp with dark style.
PopUpView(
    shape: .circle,
    shapeColor: .mint,
    text: singleLineExampleText
) {
    print("Do something on tapped on the popup.")
}
.popUpStyle(.darkPopUpStyle)
 ```
 
### Sets the style of `PopUpView`
Note: Default PopUp style is set to `light`. You can try other styles or create your own style.

 ```swift
.customPopUpStyle
.darkPopUpStyle
.newYorkPopUpStyle
 ```
 
## Requirements
- iOS 14.0 +
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)

## License
- PopUpSwift is distributed under the MIT License.
