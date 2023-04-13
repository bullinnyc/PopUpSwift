//
//  ResourcesManager.swift
//  
//
//  Created by Dmitry Kononchuk on 14.02.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

#if canImport(UIKit)
import UIKit

// Colors.
public let theia = UIColor(
    named: "theia",
    in: Bundle.module,
    compatibleWith: nil
) ?? UIColor()

public let mint = UIColor(
    named: "mint",
    in: Bundle.module,
    compatibleWith: nil
) ?? UIColor()

// Images.
public let brooklynBridge = UIImage(
    named: "BrooklynBridge",
    in: Bundle.module,
    compatibleWith: nil
) ?? UIImage()
#endif
