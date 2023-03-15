//
//  PopUpView.swift
//  
//
//  Created by Dmitry Kononchuk on 14.02.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

/// Show a popup view.
public struct PopUpView: View {
    // MARK: - Property Wrappers
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.popUpStyle) private var popUpStyle
    
    @State private var anyViewSize: CGSize = .zero
    @State private var anyViewGlobalCoordinate: CGPoint = .zero
    @State private var popUpSize: CGSize = .zero
    @State private var isShowPopUp = false
    @State private var isBouncePopUp = false
    @State private var isShowInfo = false
    @State private var popUpTimer: Timer?
    @State private var bounceTimer: Timer?
    @State private var infoTimer: Timer?
    @State private var orientation: UIDeviceOrientation = .unknown
    
    // MARK: - Private Properties
    private let anyView: AnyView
    private let text: String
    private let textAlignment: TextAlignment
    private let fontName: String
    private var fontSize: CGFloat
    private let padding: CGFloat
    private let maxWidth: CGFloat
    private let popUpType: PopUpType
    private let popUpOffsetY: CGFloat
    private let isBounceAnimation: Bool
    private let zIndex: Double
    private let timeInterval: Double?
    private let infoText: String
    private let completion: (() -> Void)?
    
    static private let popUpInsets = EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
    static private let strokeLineWidth: CGFloat = 0.9
    static private let bounce: CGFloat = 3
    
    // MARK: - Public Enums
    public enum PopUpType {
        case top
        case bottom
    }
    
    public enum ShapeType {
        case circle
        case heart
    }
    
    // MARK: - Private Enums
    private enum PopUpError: String {
        case noSpace = "Not enough space to show the popup"
    }
    
    // MARK: - body Property
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                if isShowPopUp {
                    ZStack {
                        PopUpStyle {
                            Group {
                                if let borderColor = popUpStyle.borderColor {
                                    PopUpShape(
                                        cornerRadius: popUpStyle.cornerRadius,
                                        arrowSize: popUpStyle.arrowSize,
                                        arrowMidX: getTriangleCoordinateX(geometry)
                                    )
                                    .overlay(
                                        PopUpShape(
                                            cornerRadius: popUpStyle.cornerRadius,
                                            arrowSize: popUpStyle.arrowSize,
                                            arrowMidX: getTriangleCoordinateX(geometry)
                                        )
                                        .stroke(
                                            borderColor,
                                            lineWidth: Self.strokeLineWidth
                                        )
                                    )
                                } else {
                                    PopUpShape(
                                        cornerRadius: popUpStyle.cornerRadius,
                                        arrowSize: popUpStyle.arrowSize,
                                        arrowMidX: getTriangleCoordinateX(geometry)
                                    )
                                }
                            }
                            .rotation3DEffect(
                                .degrees(popUpType == .top ? 0 : 180),
                                axis: (x: 1, y: 0, z: 0)
                            )
                            .opacity(popUpStyle.opacity)
                            .shadow(
                                color: popUpStyle.shadowColor?
                                    .opacity(popUpStyle.shadowOpacity) ?? .clear,
                                radius: popUpStyle.shadowRadius,
                                x: popUpStyle.shadowOffset.x,
                                y: popUpStyle.shadowOffset.y
                            )
                        }
                        
                        ScrollView {
                            Text(text)
                                .foregroundColor(popUpStyle.textColor)
                                .multilineTextAlignment(textAlignment)
                                .font(.custom(fontName, size: fontSize))
                                .sizeOfView { size in
                                    popUpSize = size
                                }
                                .frame(width: maxWidth)
                                .frame(maxWidth: popUpSize.width)
                                .padding(padding)
                        }
                        .disabled(!isPopUpNotInScreenFrame())
                        .onTapGesture {
                            isShowPopUp.toggle()
                            startOrStopPopUpTimer()
                            stopBounceTimerIfNeeded()
                            completion?()
                        }
                        .onLongPressGesture {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = text
                            
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            withAnimation { isShowInfo = true }
                            startOrStopInfoTimer()
                        } onPressingChanged: { inProgress in
                            if !inProgress, isPopUpNotInScreenFrame() {
                                startOrStopPopUpTimer()
                                
                                if isBounceAnimation {
                                    isBouncePopUp = false
                                    startBounceTimer()
                                }
                            }
                        }
                    }
                    .transition(.popUpTransition())
                    .position(
                        x: getRectangleCoordinateX(geometry),
                        y: getRectangleCoordinateY(geometry)
                    )
                    .offset(y: isBouncePopUp ? getBounceOffset() : 0)
                    .animation(
                        isBouncePopUp
                        ? .linear(duration: 0.4)
                            .repeatForever(autoreverses: true)
                        : .easeInOut,
                        value: isBouncePopUp
                    )
                }
                
                ZStack {
                    if isShowInfo {
                        Text(infoText)
                            .foregroundColor(.white)
                            .font(.custom("Seravek", size: 18))
                            .padding(8)
                            .background(Color.black)
                            .cornerRadius(8)
                            .fixedSize()
                            .opacity(isShowInfo ? 0.8 : 0)
                            .offset(x: getInfoOffsetX(), y: getInfoOffsetY())
                    }
                    
                    anyView
                        .disabled(true)
                        .sizeOfView { size in
                            anyViewSize = size
                        }
                        .fixedSize()
                        .position(
                            x: geometry.size.width * 0.5,
                            y: geometry.size.height * 0.5
                        )
                        .coordinateOfView { coordinate in
                            anyViewGlobalCoordinate = coordinate
                        }
                        .onTapGesture {
                            if isEnoughSpaceToPopup() {
                                isShowPopUp.toggle()
                                startOrStopPopUpTimer()
                                stopBounceTimerIfNeeded()
                            } else {
                                print("**** \(PopUpView.self) error: \(PopUpError.noSpace.rawValue) \(popUpType).")
                            }
                        }
                }
            }
            .frame(
                width: popUpSize.width + padding * 2,
                height: abs(getPopUpHeight())
            )
        }
        .frame(width: anyViewSize.width, height: anyViewSize.height)
        .zIndex(zIndex)
        .onChange(of: isShowPopUp) { newValue in
            guard isBounceAnimation else { return }
            
            DispatchQueue.main.async {
                isBouncePopUp = newValue
            }
        }
        .onRotate { newOrientation in
            // Required for floating animation to work
            // when rotated on iOS 15.0 and above.
            orientation = newOrientation
        }
    }
    
    // MARK: - Initializers
    /// - Parameters:
    ///   - anyView: Any view to be displayed.
    ///   - text: Text to be displayed.
    ///   - textAlignment: Text alignment.
    ///   - fontName: Font name.
    ///   - fontSize: Font size.
    ///   - padding: Padding for text.
    ///   - maxWidth: Maximum width that the popup can take.
    ///   - popUpType: Popup opening type.
    ///   - popUpOffsetY: Popup offset y position.
    ///   - isBounceAnimation: Set to `true` for bouncing animation of the popup.
    ///   - zIndex: Controls the display order of overlapping views.
    ///   - timeInterval: Time interval for the popup to be visible.
    ///   - infoText: Text to be displayed for info view.
    public init(
        anyView: AnyView,
        text: String,
        textAlignment: TextAlignment = .center,
        fontName: String = "Seravek",
        fontSize: CGFloat = 16,
        padding: CGFloat = 8,
        maxWidth: CGFloat = 240,
        popUpType: PopUpType = .top,
        popUpOffsetY: CGFloat = 6,
        isBounceAnimation: Bool = false,
        zIndex: Double = .zero,
        timeInterval: Double? = nil,
        infoText: String = "Copied to clipboard",
        completion: (() -> Void)? = nil
    ) {
        self.anyView = anyView
        self.text = text
        self.textAlignment = textAlignment
        self.fontName = fontName
        self.fontSize = fontSize
        self.padding = padding
        self.maxWidth = maxWidth
        self.popUpType = popUpType
        self.popUpOffsetY = popUpOffsetY
        self.isBounceAnimation = isBounceAnimation
        self.zIndex = zIndex
        self.timeInterval = timeInterval
        self.infoText = infoText
        self.completion = completion
    }
    
    /// - Parameters:
    ///   - shape: Shape view to be displayed.
    ///   - shapeColor: Shape color.
    ///   - shapeSize: Shape size.
    ///   - text: Text to be displayed.
    ///   - textAlignment: Text alignment.
    ///   - fontName: Font name.
    ///   - fontSize: Font size.
    ///   - padding: Padding for text.
    ///   - maxWidth: Maximum width that the popup can take.
    ///   - popUpType: Popup opening type.
    ///   - popUpOffsetY: Popup offset y position.
    ///   - isBounceAnimation: Set to `true` for bouncing animation of the popup.
    ///   - zIndex: Controls the display order of overlapping views.
    ///   - timeInterval: Time interval for the popup to be visible.
    ///   - infoText: Text to be displayed for info view.
    public init(
        shape: ShapeType,
        shapeColor: Color,
        shapeSize: CGSize = CGSize(width: 60, height: 60),
        text: String,
        textAlignment: TextAlignment = .center,
        fontName: String = "Seravek",
        fontSize: CGFloat = 16,
        padding: CGFloat = 8,
        maxWidth: CGFloat = 240,
        popUpType: PopUpType = .top,
        popUpOffsetY: CGFloat = 6,
        isBounceAnimation: Bool = false,
        zIndex: Double = .zero,
        timeInterval: Double? = nil,
        infoText: String = "Copied to clipboard",
        completion: (() -> Void)? = nil
    ) {
        switch shape {
        case .circle:
            anyView = AnyView(ColorCircleView(color: shapeColor, size: shapeSize))
        case .heart:
            anyView = AnyView(HeartView(color: shapeColor, size: shapeSize))
        }
        
        self.text = text
        self.textAlignment = textAlignment
        self.fontName = fontName
        self.fontSize = fontSize
        self.padding = padding
        self.maxWidth = maxWidth
        self.popUpType = popUpType
        self.popUpOffsetY = popUpOffsetY
        self.isBounceAnimation = isBounceAnimation
        self.zIndex = zIndex
        self.timeInterval = timeInterval
        self.infoText = infoText
        self.completion = completion
    }
    
    // MARK: - Private Methods
    private func getInfoOffsetX() -> CGFloat {
        let scaleScreenWidth = UIWindow.screenSize.width * 0.5
        return scaleScreenWidth - anyViewGlobalCoordinate.x
    }
    
    private func getInfoOffsetY() -> CGFloat {
        let scaleScreenHeight = UIWindow.screenSize.height * 0.9
        return scaleScreenHeight - anyViewGlobalCoordinate.y
    }
    
    private func getTriangleCoordinateX(_ geometry: GeometryProxy) -> CGFloat {
        if geometry.frame(in: .global).maxX > UIWindow.screenSize.width {
            return geometry.size.width * 0.5 -
            (UIWindow.screenSize.width - geometry.frame(in: .global).maxX) +
            Self.popUpInsets.trailing
        }
        
        if geometry.frame(in: .global).minX < .zero {
            return geometry.size.width * 0.5 +
            geometry.frame(in: .global).minX -
            Self.popUpInsets.leading
        }
        
        return geometry.size.width * 0.5
    }
    
    private func getRectangleCoordinateX(_ geometry: GeometryProxy) -> CGFloat {
        if geometry.frame(in: .global).maxX > UIWindow.screenSize.width {
            return geometry.size.width * 0.5 +
            (UIWindow.screenSize.width - geometry.frame(in: .global).maxX) -
            Self.popUpInsets.trailing
        }
        
        if geometry.frame(in: .global).minX < .zero {
            return geometry.size.width * 0.5 -
            geometry.frame(in: .global).minX +
            Self.popUpInsets.leading
        }
        
        return geometry.size.width * 0.5
    }
    
    private func getRectangleCoordinateY(_ geometry: GeometryProxy) -> CGFloat {
        if isMenuTop() {
            return geometry.frame(in: .local).minY - popUpStyle.arrowSize.height -
            anyViewSize.height * 0.5 - popUpOffsetY
        }
        
        return geometry.frame(in: .local).maxY + popUpStyle.arrowSize.height +
        anyViewSize.height * 0.5 + popUpOffsetY
    }
    
    private func getPopUpHeight() -> CGFloat {
        let height: CGFloat
        
        if isPopUpNotInScreenFrame() {
            let popUpYPosition = getPopUpYPosition()
            
            if isMenuTop() {
                height = popUpYPosition + popUpSize.height +
                padding * 2 - Self.popUpInsets.top - getBounce()
            } else {
                height = popUpYPosition - UIWindow.screenSize.height -
                popUpSize.height - padding * 2 + Self.popUpInsets.bottom + getBounce()
            }
        } else {
            height = popUpSize.height + padding * 2
        }
        
        return height
    }
    
    private func isPopUpNotInScreenFrame() -> Bool {
        if isMenuTop() {
            return getPopUpYPosition() < .zero
        }
        
        return getPopUpYPosition() > UIWindow.screenSize.height
    }
    
    private func getPopUpYPosition() -> CGFloat {
        if isMenuTop() {
            let popUpMinYPosition = anyViewGlobalCoordinate.y - safeAreaInsets.top -
            anyViewSize.height * 0.5 - popUpSize.height -
            popUpOffsetY - popUpStyle.arrowSize.height - padding * 2
            
            return popUpMinYPosition
        }
        
        let popUpMaxYPosition = anyViewGlobalCoordinate.y + safeAreaInsets.bottom +
        anyViewSize.height * 0.5 + popUpSize.height +
        popUpOffsetY + popUpStyle.arrowSize.height + padding * 2
        
        return popUpMaxYPosition
    }
    
    private func isEnoughSpaceToPopup() -> Bool {
        if isMenuTop() {
            let popUpMaxYPosition = anyViewGlobalCoordinate.y - anyViewSize.height * 0.5 -
            popUpOffsetY - popUpStyle.arrowSize.height -
            Self.popUpInsets.top - getBounce()
            
            return popUpMaxYPosition > safeAreaInsets.top
        }
        
        let popUpMinYPosition = anyViewGlobalCoordinate.y + anyViewSize.height * 0.5 +
        popUpOffsetY + popUpStyle.arrowSize.height +
        Self.popUpInsets.bottom + getBounce()
        
        return popUpMinYPosition < UIWindow.screenSize.height - safeAreaInsets.bottom
    }
    
    private func getBounceOffset() -> CGFloat {
        popUpType == .top ? -Self.bounce : Self.bounce
    }
    
    private func getBounce() -> CGFloat {
        isBounceAnimation ? Self.bounce : .zero
    }
    
    private func isMenuTop() -> Bool {
        popUpType == .top
    }
    
    private func startBounceTimer() {
        stopBounceTimerIfNeeded()
        
        if !isBouncePopUp {
            bounceTimer = Timer.scheduledTimer(
                withTimeInterval: 8,
                repeats: false
            ) { _ in
                isBouncePopUp.toggle()
            }
        }
    }
    
    private func stopBounceTimerIfNeeded() {
        guard isBounceAnimation else { return }
        
        if let runningTimer = bounceTimer {
            runningTimer.invalidate()
            bounceTimer = nil
        }
    }
    
    private func startOrStopPopUpTimer() {
        guard let timeInterval = timeInterval else { return }
        
        if let runningTimer = popUpTimer {
            runningTimer.invalidate()
            popUpTimer = nil
        }
        
        if isShowPopUp {
            popUpTimer = Timer.scheduledTimer(
                withTimeInterval: timeInterval,
                repeats: false
            ) { _ in
                isShowPopUp.toggle()
            }
        }
    }
    
    private func startOrStopInfoTimer() {
        if let runningTimer = infoTimer {
            runningTimer.invalidate()
            infoTimer = nil
        }
        
        infoTimer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: false
        ) { _ in
            isShowInfo.toggle()
        }
    }
}
