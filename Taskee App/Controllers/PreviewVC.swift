//
//  PreviewViewController.swift
//  Taskee App
//
//  Created by Cao Mai on 7/14/20.
//  Copyright © 2020 Make School. All rights reserved.
// testing branch

import UIKit

class PreviewVC: UIViewController {
    
    var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
//        image.layer.masksToBounds = true
//        image.layer.cornerRadius = 12
        return image
    }()
    var taskDueDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(taskTitleLabel)
        view.addSubview(taskDueDateLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width/1.3),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            taskTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 45)
        ])
        
        NSLayoutConstraint.activate([
            taskDueDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDueDateLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 45)
        ])
    }
    
    func configureTask(with task: Task){
        taskTitleLabel.text = task.title
        imageView.image = UIImage(data: task.taskImage!)
        taskDueDateLabel.text = task.status ? "Completed on \(dateFormatter.string(from: task.dateCompleted!))" : "Due by \(dateFormatter.string(from: task.dueDate!))"
//        taskDueDateLabel.textColor = task.status ? #colorLiteral(red: 0.2980392157, green: 0.7843137255, blue: 0.262745098, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        taskDueDateLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

        view.backgroundColor = task.status ?  #colorLiteral(red: 0.6746127009, green: 0.9552420974, blue: 0.4862803817, alpha: 1) : .white
    }
    
}
