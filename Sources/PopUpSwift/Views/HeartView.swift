//
//  HeartView.swift
//  
//
//  Created by Dmitry Kononchuk on 14.02.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct HeartView: View {
    // MARK: - Property Wrappers
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Public Properties
    let color: Color
    let size: CGSize
    
    // MARK: - body Property
    var body: some View {
        HeartShape()
            .fill(color)
            .overlay(
                HeartShape()
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
