//
//  Extensions.swift
//  Taskee App
//
//  Created by Cao Mai on 6/29/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func color(red: NSNumber, green: NSNumber, blue: NSNumber, alpha: NSNumber?=1) -> UIColor? {
        return UIColor(red: CGFloat(truncating: red) / 255.0,
                       green: CGFloat(truncating: green) / 255.0,
                       blue: CGFloat(truncating: blue) / 255.0,
                       alpha: CGFloat(truncating: alpha!))
    }
    
    // color to hex string
    // https://stackoverflow.com/questions/26341008/how-to-convert-uicolor-to-hex-and-display-in-nslog
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }
    
    // hex to color
    // https://stackoverflow.com/questions/26341008/how-to-convert-uicolor-to-hex-and-display-in-nslog
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
      var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
      
      if (cString.hasPrefix("#")) { cString.removeFirst() }
      
      if ((cString.count) != 6) {
          self.init("ff0000") // return red color for wrong hex input
        return
      }
      
      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      
      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha)
    }

}
