//
//  UIColorExtensions.swift
//  MindNodeLayout
//
//  Created by anthann on 2019/10/10.
//  Copyright © 2019 anthann. All rights reserved.
//

import UIKit

internal extension UIColor {
    
    /// A random color.
    static var random: UIColor {
        UIColor(red: .random(in: 0...255) / 255.0,
                green: .random(in: 0...255) / 255.0,
                blue: .random(in: 0...255) / 255.0,
                alpha: 1.0)
    }
}
