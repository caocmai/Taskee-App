//
//  UITextField.swift
//  Taskee App
//
//  Created by Cao Mai on 7/10/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

extension UITextField { // Gives you done button when end of textfields, otherwise get next button to move to next UItextfield
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
}
