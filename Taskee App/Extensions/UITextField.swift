//
//  UITextField.swift
//  Taskee App
//
//  Created by Cao Mai on 7/10/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

/// from https://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
extension UITextField { // Gives you done button when end of textfields, otherwise get next button to move to next UItextfield, (form entry helper)
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(self.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    // add underline to uitextfield
    func setBottomBorder() {
      self.borderStyle = .none
      self.layer.backgroundColor = UIColor.white.cgColor

      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.gray.cgColor
      self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
      self.layer.shadowOpacity = 0.3
      self.layer.shadowRadius = 0.0
    }
}
