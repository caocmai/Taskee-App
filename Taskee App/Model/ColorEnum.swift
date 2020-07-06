//
//  ColorEnum.swift
//  Taskee App
//
//  Created by Cao Mai on 7/5/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

enum customColor {
    case myGreen
    case myYellow
    
    var myCustomColor: UIColor! {
        switch self {
        case .myGreen:
            return UIColor.color(red: 12, green: 32, blue: 12)
        case .myYellow:
            return UIColor.color(red: 34, green: 13, blue: 12)
        }
    }
}

