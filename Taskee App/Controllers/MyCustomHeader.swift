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

        
        var title : UILabel = {
            let title = UILabel()
            title.font = UIFont.systemFont(ofSize: 30.0)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            return title
        }()
    
    var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
        

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
//            self.contentView.backgroundColor = .white
            self.contentView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureContents() {

            self.contentView.addSubview(title)
            self.contentView.addSubview(headerImage)

            NSLayoutConstraint.activate([
                self.contentView.heightAnchor.constraint(equalToConstant: 60),
                headerImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
                headerImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                headerImage.heightAnchor.constraint(equalToConstant: 50),
                title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                title.leadingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: 15),
                

    //            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        }

}
