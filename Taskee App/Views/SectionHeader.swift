//
//  MyCustomHeader.swift
//  Taskee App
//
//  Created by Cao Mai on 7/29/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
    
    static var identifier: String = "sectionHeader"
    
    let title: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Task Title"
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.textColor = #colorLiteral(red: 0.3720658123, green: 0.3721333742, blue: 0.3720569015, alpha: 1)
        textField.setBottomBorder()
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContents() {
        self.contentView.addSubview(title)
        self.contentView.addSubview(headerImage)
        self.contentView.backgroundColor = .white

        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40),
            
            headerImage.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10),
            headerImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 1),
            headerImage.heightAnchor.constraint(equalToConstant: 23),
        ])
    }
    
    internal func configureTitle(_ sectionTitle: String){
        let dropLeadingIndexString = String(sectionTitle.dropFirst())
        title.text = dropLeadingIndexString
        
        switch dropLeadingIndexString {
        case "Active Projects":
            let systemEllipsis = UIImage(systemName: "ellipsis.circle")
            let greenSystemEllipsis = systemEllipsis?.withTintColor(#colorLiteral(red: 0.3276759386, green: 0.759457171, blue: 0.1709203422, alpha: 1), renderingMode: .alwaysOriginal)
            headerImage.image = greenSystemEllipsis
        case "New Projects":
            let systemCircle = UIImage(systemName: "circle")
            let greenSystemCircle = systemCircle?.withTintColor(#colorLiteral(red: 0.3276759386, green: 0.759457171, blue: 0.1709203422, alpha: 1), renderingMode: .alwaysOriginal)
            headerImage.image = greenSystemCircle
        case "Completed Projects":
            let systemCheckCircle = UIImage(systemName: "checkmark.circle.fill")
            let greenSystemCheckCircle = systemCheckCircle?.withTintColor(#colorLiteral(red: 0.3276759386, green: 0.759457171, blue: 0.1709203422, alpha: 1), renderingMode: .alwaysOriginal)
            headerImage.image = greenSystemCheckCircle
        default:
            print("section title not valid")
            headerImage.image = UIImage.init(systemName: "circle")
        }
    }
    
}
