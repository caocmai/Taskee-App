//
//  ProjectCell.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    static var identifier = "projectCell"
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    let cellTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kailasa", size: 20)
        return label
    }()
    
    let taskImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let pendingTasksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kailasa", size: 14)

        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUIForTask(with task: Task) {
        self.contentView.addSubview(taskImage)
        
        NSLayoutConstraint.activate([
            taskImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            taskImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            taskImage.widthAnchor.constraint(equalToConstant: 60),
            taskImage.heightAnchor.constraint(equalToConstant: 60),
            cellTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -1),
            cellTitleLabel.leadingAnchor.constraint(equalTo: self.taskImage.trailingAnchor, constant: 8),
            pendingTasksLabel.leadingAnchor.constraint(equalTo: self.taskImage.trailingAnchor, constant: 5)
        ])

        taskImage.layer.masksToBounds = true
        taskImage.layer.cornerRadius = 30
        cellTitleLabel.text = task.title
        taskImage.isHidden = false
        taskImage.image = UIImage(data: task.taskImage!)
        
        pendingTasksLabel.text = task.status ? "Completed on \(dateFormatter.string(from: task.dateCompleted!))" : "Due by \(dateFormatter.string(from: task.dueDate!))"
        pendingTasksLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func configureUIForProject(with project: Project) {
//        print(project.taskCount)
        NSLayoutConstraint.activate([
            cellTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -3),
            cellTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            pendingTasksLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
        ])
        
        
        cellTitleLabel.text = project.name
        cellTitleLabel.textColor = project.color as? UIColor
        accessoryType = .disclosureIndicator
        var pendingTaskCount = 0
        for task in project.projectTasks! {
            if (task as! Task).status == false {
                pendingTaskCount += 1
            }
        }
        
        if project.projectTasks?.count == 0 {
            pendingTasksLabel.text = "Tasks not set"
            pendingTasksLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.7964469178)
        }
        else if pendingTaskCount == 0 {
            pendingTasksLabel.text = "Tasks completed!"
            pendingTasksLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8248440974, blue: 0.8039215803, alpha: 1)
        } else {
            pendingTasksLabel.text = "\(pendingTaskCount) Pending task\(pendingTaskCount <= 1 ? "" : "s")"
            pendingTasksLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.addSubview(cellTitleLabel)
        self.contentView.addSubview(pendingTasksLabel)
        pendingTasksLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
    }

}
