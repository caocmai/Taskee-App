//
//  MyCustomHeader.swift
//  Taskee App
//
//  Created by Cao Mai on 7/29/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class MyCustomHeader: UITableViewHeaderFooterView {

    static var identifier: String = "sectionHeader"
    
    let title: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Task Title"
        textField.textAlignment = .right
        textField.tag = 0
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.textColor = #colorLiteral(red: 0.3720658123, green: 0.3721333742, blue: 0.3720569015, alpha: 1)
        return textField
    }()
    
    var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
        

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
            self.contentView.backgroundColor = .white
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureContents() {
            self.contentView.addSubview(title)
            self.contentView.addSubview(headerImage)
            
            title.setBottomBorder()
            title.isUserInteractionEnabled = false

            NSLayoutConstraint.activate([
                self.contentView.heightAnchor.constraint(equalToConstant: 40),
                title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
                title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40),
                
                headerImage.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10),
                headerImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                headerImage.heightAnchor.constraint(equalToConstant: 23),

            ])
        }
    
    func configureTitle(_ sectionTitle: String){
        title.text = sectionTitle
        switch sectionTitle {
        case "Pending Tasks":
            let systemEllipsis = UIImage(systemName: "ellipsis.circle")
            let greenSystemEllipsis = systemEllipsis?.withTintColor(#colorLiteral(red: 0.3276759386, green: 0.759457171, blue: 0.1709203422, alpha: 1), renderingMode: .alwaysOriginal)
            headerImage.image = greenSystemEllipsis
        case "Task Not Set":
            let systemCircle = UIImage(systemName: "circle")
            let greenSystemCircle = systemCircle?.withTintColor(#colorLiteral(red: 0.3276759386, green: 0.759457171, blue: 0.1709203422, alpha: 1), renderingMode: .alwaysOriginal)
            headerImage.image = greenSystemCircle
        case "Tasks Completed":
            let systemCheckCircle = UIImage(systemName: "checkmark.circle.fill")
            let greenSystemCheckCircle = systemCheckCircle?.withTintColor(#colorLiteral(red: 0.3276759386, green: 0.759457171, blue: 0.1709203422, alpha: 1), renderingMode: .alwaysOriginal)
            headerImage.image = greenSystemCheckCircle
        default:
            print("section title not valid")
            headerImage.image = UIImage.init(systemName: "circle")
        }
    }

}

extension UITextField {
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

// extension UITextField {
//  func setBottomBorder() {
//    self.borderStyle = UITextField.BorderStyle.none
//    let border = CALayer()
//    let width = CGFloat(1.0)
//    border.borderColor = UIColor.white.cgColor
//    border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
//    border.borderWidth = width
//    self.layer.addSublayer(border)
//    self.layer.masksToBounds = true
//   }
//}
