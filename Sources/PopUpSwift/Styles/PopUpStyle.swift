//
//  PopUpStyle.swift
//  
//
//  Created by Dmitry Kononchuk on 14.02.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

// MARK: - Style Protocol
public protocol PopUpStyleProtocol {
    var textColor: Color { get }
    var backgroundColor: Color { get }
    var borderColor: Color? { get }
    var cornerRadius: CGFloat { get }
    var arrowSize: CGSize { get }
    var opacity: Double { get }
    var shadowColor: Color? { get }
    var shadowOpacity: Double { get }
    var shadowRadius: CGFloat { get }
    var shadowOffset: CGPoint { get }
    
    associatedtype Body: View
    typealias Configuration = PopUpStyleConfiguration
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - Ext. Use style with static property
extension PopUpStyleProtocol where Self == CustomPopUpStyle {
    /// A popup with custom style.
    ///
    /// - Parameters:
    ///   - textColor: Popup text color.
    ///   - backgroundColor: Popup background color.
    ///   - borderColor: Popup border color.
    ///   - cornerRadius: Popup corner radius.
    ///   - arrowSize: Popup arrow size.
    ///   - opacity: Popup opacity.
    ///   - shadowColor: Popup shadow color.
    ///   - shadowOpacity: Popup shadow opacity.
    ///   - shadowRadius: Popup shadow radius.
    ///   - shadowOffset: Popup shadow offset.
    public static func customPopUpStyle(
        textColor: Color,
        backgroundColor: Color,
        borderColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        arrowSize: CGSize = CGSize(width: 8, height: 8),
        opacity: Double = 0.8,
        shadowColor: Color? = .black,
        shadowOpacity: Double = 0.4,
        shadowRadius: CGFloat = 10,
        shadowOffset: CGPoint = CGPoint(x: 2, y: 4)
    ) -> CustomPopUpStyle {
        CustomPopUpStyle(
            textColor: textColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            cornerRadius: cornerRadius,
            arrowSize: arrowSize,
            opacity: opacity,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset
        )
    }
}

extension PopUpStyleProtocol where Self == DarkPopUpStyle {
    /// A popup with dark style.
    public static var darkPopUpStyle: DarkPopUpStyle { DarkPopUpStyle() }
}

extension PopUpStyleProtocol where Self == NewYorkPopUpStyle {
    /// A popup with specific style.
    public static var newYorkPopUpStyle: NewYorkPopUpStyle { NewYorkPopUpStyle() }
}

// MARK: - Style Content
struct PopUpStyle<Content: View>: View {
    @Environment(\.popUpStyle) private var style
    let content: () -> Content
    
    var body: some View {
        style
            .makeBody(
                configuration: PopUpStyleConfiguration(
                    label: PopUpStyleConfiguration.Label(content: content())
                )
            )
    }
}

// MARK: - Style Configuration
public struct PopUpStyleConfiguration {
    /// A type-erased content of a `PopUpStyle`.
    struct Label: View {
        let body: AnyView
        
        init<Content: View>(content: Content) {
            body = AnyView(content)
        }
    }
    
    let label: PopUpStyleConfiguration.Label
}

// MARK: - Base view styles
/// A popup with custom style.
public struct CustomPopUpStyle: PopUpStyleProtocol {
    public let textColor: Color
    public let backgroundColor: Color
    public let borderColor: Color?
    public let cornerRadius: CGFloat
    public let arrowSize: CGSize
    public let opacity: Double
    public let shadowColor: Color?
    public let shadowOpacity: Double
    public let shadowRadius: CGFloat
    public let shadowOffset: CGPoint
    
    /// - Parameters:
    ///   - textColor: Popup text color.
    ///   - backgroundColor: Popup background color.
    ///   - borderColor: Popup border color.
    ///   - cornerRadius: Popup corner radius.
    ///   - arrowSize: Popup arrow size.
    ///   - opacity: Popup opacity.
    ///   - shadowColor: Popup shadow color.
    ///   - shadowOpacity: Popup shadow opacity.
    ///   - shadowRadius: Popup shadow radius.
    ///   - shadowOffset: Popup shadow offset.
    public init(
        textColor: Color,
        backgroundColor: Color,
        borderColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        arrowSize: CGSize = CGSize(width: 8, height: 8),
        opacity: Double = 0.8,
        shadowColor: Color? = .black,
        shadowOpacity: Double = 0.4,
        shadowRadius: CGFloat = 10,
        shadowOffset: CGPoint = CGPoint(x: 2, y: 4)
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.arrowSize = arrowSize
        self.opacity = opacity
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(backgroundColor)
    }
}

/// A popup with dark style.
public struct DarkPopUpStyle: PopUpStyleProtocol {
    public let textColor: Color
    public let backgroundColor: Color
    public let borderColor: Color?
    public let cornerRadius: CGFloat
    public let arrowSize: CGSize
    public let opacity: Double
    public let shadowColor: Color?
    public let shadowOpacity: Double
    public let shadowRadius: CGFloat
    public let shadowOffset: CGPoint
    
    public init() {
        textColor = .white
        backgroundColor = .black
        borderColor = nil
        cornerRadius = 8
        arrowSize = CGSize(width: 8, height: 8)
        opacity = 0.8
        shadowColor = .black
        shadowOpacity = 0.4
        shadowRadius = 10
        shadowOffset = CGPoint(x: 2, y: 4)
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(backgroundColor)
    }
}

/// A popup with specific style.
public struct NewYorkPopUpStyle: PopUpStyleProtocol {
    public let textColor: Color
    public let backgroundColor: Color
    public let borderColor: Color?
    public let cornerRadius: CGFloat
    public let arrowSize: CGSize
    public let opacity: Double
    public let shadowColor: Color?
    public let shadowOpacity: Double
    public let shadowRadius: CGFloat
    public let shadowOffset: CGPoint
    
    public init() {
        textColor = .white.opacity(0.8)
        backgroundColor = .secondary
        borderColor = .white.opacity(0.8)
        cornerRadius = 8
        arrowSize = CGSize(width: 8, height: 8)
        opacity = 0.8
        shadowColor = .black
        shadowOpacity = 0.4
        shadowRadius = 10
        shadowOffset = CGPoint(x: 2, y: 4)
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(backgroundColor)
    }
}

// MARK: - Default view style
/// A popup with light style.
private struct LightPopUpStyle: PopUpStyleProtocol {
    let textColor: Color
    let backgroundColor: Color
    let borderColor: Color?
    let cornerRadius: CGFloat
    let arrowSize: CGSize
    let opacity: Double
    let shadowColor: Color?
    let shadowOpacity: Double
    let shadowRadius: CGFloat
    let shadowOffset: CGPoint
    
    init() {
        textColor = .black
        backgroundColor = .white
        borderColor = nil
        cornerRadius = 8
        arrowSize = CGSize(width: 8, height: 8)
        opacity = 0.8
        shadowColor = .black
        shadowOpacity = 0.4
        shadowRadius = 10
        shadowOffset = CGPoint(x: 2, y: 4)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(backgroundColor)
    }
}

// MARK: - Setup style
struct AnyPopUpStyle: PopUpStyleProtocol {
    let textColor: Color
    let backgroundColor: Color
    let borderColor: Color?
    let cornerRadius: CGFloat
    let arrowSize: CGSize
    let opacity: Double
    let shadowColor: Color?
    let shadowOpacity: Double
    let shadowRadius: CGFloat
    let shadowOffset: CGPoint
    
    private let _makeBody: (Configuration) -> AnyView
    
    init<S: PopUpStyleProtocol>(style: S) {
        textColor = style.textColor
        backgroundColor = style.backgroundColor
        borderColor = style.borderColor
        cornerRadius = style.cornerRadius
        arrowSize = style.arrowSize
        opacity = style.opacity
        shadowColor = style.shadowColor
        shadowOpacity = style.shadowOpacity
        shadowRadius = style.shadowRadius
        shadowOffset = style.shadowOffset
        
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - Create an environment key
private struct PopUpStyleKey: EnvironmentKey {
    static let defaultValue = AnyPopUpStyle(style: LightPopUpStyle())
}

// MARK: - Ext. New value to environment values
extension EnvironmentValues {
    var popUpStyle: AnyPopUpStyle {
        get { self[PopUpStyleKey.self] }
        set { self[PopUpStyleKey.self] = newValue }
    }
}

// MARK: - Ext. Dedicated convenience view modifier
extension View {
    /// Sets the style of this view.
    ///
    /// Set to `.darkPopUpStyle`
    /// or `.customPopUpStyle(textColor:backgroundColor:)`
    /// or any other style to apply the style.
    ///
    ///     let exampleView = Text("Example")
    ///         .foregroundColor(.white)
    ///         .font(.custom("Seravek", size: 18))
    ///         .padding(8)
    ///         .background(.pink)
    ///         .cornerRadius(8)
    ///
    ///     PopUpView(anyView: exampleView, text: "Hello, world!")
    ///         .popUpStyle(.darkPopUpStyle)
    ///
    /// - Parameter style: The popup style.
    ///
    /// - Returns: A view that sets the style of this view.
    public func popUpStyle<S: PopUpStyleProtocol>(_ style: S) -> some View {
        environment(\.popUpStyle, AnyPopUpStyle(style: style))
    }
}
