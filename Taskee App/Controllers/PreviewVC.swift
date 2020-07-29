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
//        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    var taskDueDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(taskTitleLabel)
        view.addSubview(taskDueDateLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            taskTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskTitleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -45)
        ])
        
        NSLayoutConstraint.activate([
            taskDueDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDueDateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 55)
        ])
    }
    
}