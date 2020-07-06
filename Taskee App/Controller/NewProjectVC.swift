//
//  NewProjectVC.swift
//  Taskee App
//
//  Created by Cao Mai on 7/5/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class NewProjectVC: UIViewController, ButtonBackgroundColorDelegate {
    func getButtonColor(buttonColor: UIColor) {
        self.view.backgroundColor = buttonColor
    }
    
    
    let colorGrid = ColorGrid()
    var coreDataStack: CoreDataStack? = nil
    
    let getProjectName: UITextField = {
       let textfield = UITextField()
        textfield.textColor = .blue
        textfield.placeholder = "Project Name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = .yellow
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addContraints()
        colorGrid.delegate = self
        addProjectName()
        addSaveButton()
    }
    
    func addContraints() {
        view.addSubview(colorGrid)
        colorGrid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.colorGrid.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.colorGrid.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
    }
    
    func addProjectName() {
        view.addSubview(getProjectName)
        
        NSLayoutConstraint.activate([
            self.getProjectName.bottomAnchor.constraint(equalTo: self.colorGrid.topAnchor, constant: -10),
            self.getProjectName.widthAnchor.constraint(equalToConstant: 50.0),
            self.getProjectName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func addSaveButton() {
        view.addSubview(saveButton)
        
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: self.colorGrid.bottomAnchor, constant: 10),
            self.saveButton.widthAnchor.constraint(equalToConstant: 50.0),
            self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}
