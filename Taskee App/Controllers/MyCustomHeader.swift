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

        
        let title : UILabel = {
            let title = UILabel()
            title.font = UIFont.systemFont(ofSize: 24.0)
            title.textColor = #colorLiteral(red: 0.9441635013, green: 0.9385505915, blue: 0.9484778047, alpha: 1)
            return title
        }()
        

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureContents() {
            contentView.backgroundColor = #colorLiteral(red: 0.7134668231, green: 0.7134668231, blue: 0.7134668231, alpha: 1)
            title.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(title)

            NSLayoutConstraint.activate([
                title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
    //            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        }

}
