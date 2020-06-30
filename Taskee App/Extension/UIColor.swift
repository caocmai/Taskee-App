//
//  Extensions.swift
//  Taskee App
//
//  Created by Cao Mai on 6/29/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

private extension UIColor {
    
    static func color(red: NSNumber, green: NSNumber, blue: NSNumber, alpha: NSNumber?=1) -> UIColor? {
        return UIColor(red: CGFloat(truncating: red) / 255.0,
                       green: CGFloat(truncating: green) / 255.0,
                       blue: CGFloat(truncating: blue) / 255.0,
                       alpha: CGFloat(truncating: alpha!))
    }
}
