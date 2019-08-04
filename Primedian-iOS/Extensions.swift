//
//  Extensions.swift
//  Primedian-iOS
//
//  Created by Christopher Szatmary on 2019-08-03.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 100) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255, green: CGFloat((hex >> 8) & 0xFF) / 255, blue: CGFloat(hex & 0xFF) / 255, alpha: alpha/100)
    }
}
