//
//  ColorEnum.swift
//  Taskee App
//
//  Created by Cao Mai on 7/5/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

enum customColor {
    case colorOne
    case colorTwo
    case colorThree
    case colorFour
    case colorFive
    case colorSix
    case colorSeven
    case colorEight
    case colorNine
    
    var myCustomColor: UIColor! {
        switch self {
        case .colorOne:
            return UIColor.color(red: 87, green: 117, blue: 144)
        case .colorTwo:
            return UIColor.color(red: 67, green: 170, blue: 139)
        case .colorThree:
            return UIColor.color(red: 144, green: 190, blue: 109)
        case .colorFour:
            return UIColor.color(red: 249, green: 199, blue: 79)
        case .colorFive:
            return UIColor.color(red: 201, green: 173, blue: 167)
        case .colorSix:
            return UIColor.color(red: 243, green: 114, blue: 44)
        case .colorSeven:
            return UIColor.color(red: 249, green: 65, blue: 68)
        case .colorEight:
            return UIColor.color(red: 196, green: 69, blue: 54)
        case .colorNine:
            return UIColor.color(red: 67, green: 97, blue: 255)
        }
            
    }
}

