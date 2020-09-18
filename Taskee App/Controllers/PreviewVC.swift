//
//  PreviewViewController.swift
//  Taskee App
//
//  Created by Cao Mai on 7/14/20.
//  Copyright © 2020 Make School. All rights reserved.
// testing branch

import UIKit

class PreviewVC: UIViewController {
    
    let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    let taskDueDateLabel: UILabel = {
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
    
    let statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    let taskDetailDescriptionView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.textAlignment = .center
        textView.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 18)
//        textView.backgroundColor = .green
        return textView
    }()
    
    let taskCheckmarkView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let systemCheckmark = UIImage(systemName: "checkmark.circle")
        let greenSystemCheckmark = systemCheckmark?.withTintColor(#colorLiteral(red: 0.3276759386, green: 0.759457171, blue: 0.1709203422, alpha: 1), renderingMode: .alwaysOriginal)
        image.image = greenSystemCheckmark
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let titleAndCheckmarkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(taskTitleLabel)
        self.view.addSubview(imageView)
        statusView.addSubview(taskDueDateLabel)
        self.view.addSubview(statusView)
        self.view.addSubview(taskCheckmarkView)
        self.view.addSubview(taskDetailDescriptionView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.width/1.3),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            taskTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),

            taskCheckmarkView.heightAnchor.constraint(equalToConstant: 30),
            taskCheckmarkView.widthAnchor.constraint(equalToConstant: 30),
            taskCheckmarkView.centerYAnchor.constraint(equalTo: taskTitleLabel.centerYAnchor),
            taskCheckmarkView.trailingAnchor.constraint(equalTo: taskTitleLabel.leadingAnchor, constant: -8),

        ])

        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            statusView.heightAnchor.constraint(equalToConstant: 35),
            statusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            taskDueDateLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            taskDueDateLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)

        ])

        NSLayoutConstraint.activate([
            taskDetailDescriptionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 130),
            taskDetailDescriptionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            taskDetailDescriptionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            taskDetailDescriptionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
        ])

    }
    
    internal func configureTask(with task: Task){
        configureUI()

        taskTitleLabel.text = task.title
        imageView.image = UIImage(data: task.taskImage!)
        taskDueDateLabel.text = task.isCompleted ? "Completed on \(dateFormatter.string(from: task.dateCompleted!))" : "Due by \(dateFormatter.string(from: task.dueDate!))"
        taskDueDateLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        taskDetailDescriptionView.text = task.taskDescription
        if task.taskDescription == "Empty String" || task.taskDescription == "" {
            taskDetailDescriptionView.isHidden = true
            taskTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 95).isActive = true
        } else {
            taskTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 65).isActive = true

        }

        statusView.backgroundColor = task.isCompleted ?  #colorLiteral(red: 0.6746127009, green: 0.9552420974, blue: 0.4862803817, alpha: 1) : .white
        taskCheckmarkView.isHidden = task.isCompleted ? false:true
    }
    
}
