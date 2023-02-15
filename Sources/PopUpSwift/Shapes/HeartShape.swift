//
//  HeartShape.swift
//  
//
//  Created by Dmitry Kononchuk on 14.02.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct HeartShape: Shape {
    // MARK: - Public Methods
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.height / 4),
            control1: CGPoint(x: rect.midX, y: rect.height * 3.8 / 4),
            control2: CGPoint(x: rect.minX, y: rect.midY)
        )
        
        path.addArc(
            center: CGPoint(x: rect.width / 4, y: rect.height / 4),
            radius: rect.width / 4,
            startAngle: Angle(radians: .pi),
            endAngle: Angle(radians: .zero),
            clockwise: false
        )
        
        path.addArc(
            center: CGPoint(x: rect.width * 3 / 4, y: rect.height / 4),
            radius: rect.width / 4,
            startAngle: Angle(radians: .pi),
            endAngle: Angle(radians: .zero),
            clockwise: false
        )
        
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.height),
            control1: CGPoint(x: rect.width, y: rect.midY),
            control2: CGPoint(x: rect.midX, y: rect.height * 3.8 / 4)
        )
        
        return path
    }
}
