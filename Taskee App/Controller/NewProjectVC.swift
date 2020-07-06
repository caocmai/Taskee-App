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
        self.getColor = buttonColor
    }
    
    
    let colorGrid = ColorGrid()
    var coreDataStack: CoreDataStack? = nil
    var getColor: UIColor? = nil
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitle("CLOSE", for: .normal)
        button.setTitleColor(.brown, for: .normal)
        return button
    }()

    
    let getProjectName: UITextField = {
       let textfield = UITextField()
        textfield.textColor = .blue
        textfield.placeholder = "Project Name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textAlignment = .center
        textfield.backgroundColor = .white
//        textfield.layer.cornerRadius = 7
        textfield.borderStyle = .roundedRect
        
        return textfield
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        colorGridContraints()
        colorGrid.delegate = self
        addProjectName()
        addSaveButton()
        addCloseButton()
    }
    
    func addCloseButton(){
        self.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        NSLayoutConstraint.activate([
            self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    
        
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func colorGridContraints() {
        view.addSubview(colorGrid)
        colorGrid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.colorGrid.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.colorGrid.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.colorGrid.heightAnchor.constraint(equalToConstant: self.view.frame.width / 2),
            self.colorGrid.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2)
        ])
        
    }
    
    func addProjectName() {
        view.addSubview(getProjectName)
        
        NSLayoutConstraint.activate([
            self.getProjectName.bottomAnchor.constraint(equalTo: self.colorGrid.topAnchor, constant: -10),
            self.getProjectName.widthAnchor.constraint(equalToConstant: 150.0),
            self.getProjectName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func addSaveButton() {
        view.addSubview(saveButton)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: self.colorGrid.bottomAnchor, constant: 10),
            self.saveButton.widthAnchor.constraint(equalToConstant: 50.0),
            self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func saveButtonTapped() {
        let newProject = Project(context: coreDataStack!.managedContext)
        newProject.name = getProjectName.text
        newProject.color = getColor
        coreDataStack?.saveContext()
        dismiss(animated: true, completion: nil)
    }
}
