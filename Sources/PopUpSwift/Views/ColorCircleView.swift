//
//  ColorCircleView.swift
//  
//
//  Created by Dmitry Kononchuk on 14.02.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ColorCircleView: View {
    // MARK: - Property Wrappers
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Public Properties
    let color: Color
    let size: CGSize
    
    // MARK: - body Property
    var body: some View {
        Circle()
            .fill(color)
            .overlay(
                Circle()
                    .stroke(
                        colorScheme == .dark
                        ? Color.white.opacity(0.8)
                        : Color.black.opacity(0.8),
                        lineWidth: 0.9
                    )
            )
            .frame(width: size.width, height: size.height)
    }
}
