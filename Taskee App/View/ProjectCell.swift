//
//  ProjectCell.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    
    static var identifier = "projectCell"

    
    let projectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kailasa", size: 20)
        return label
    }()
    
    
    let pendingTasksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kailasa", size: 14)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func configureProjectUI() {
        self.contentView.addSubview(projectLabel)
        self.contentView.addSubview(pendingTasksLabel)
        NSLayoutConstraint.activate([
            projectLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            projectLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            pendingTasksLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            pendingTasksLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureProjectUI()


    }

}
