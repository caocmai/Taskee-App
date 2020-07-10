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
    
    var selectedProject: Project?
    let colorGrid = ColorGrid()
    var coreDataStack: CoreDataStack?
    var getColor: UIColor? = nil

    
    let getProjectName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Project Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.backgroundColor = .white
        //        textfield.layer.cornerRadius = 7
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLayoutSubviews() {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        colorGridContraints()
        colorGrid.delegate = self
        editProjectSetup()
        addProjectName()
        addSaveButton()
        //        addCloseButton()
        addNavBar()
    }
    
    func editProjectSetup(){
        if selectedProject != nil {
            getProjectName.text = selectedProject?.name
            view.backgroundColor = selectedProject?.color as? UIColor
            self.title = "Edit \(selectedProject?.name ?? "Unnamed")"
            self.saveButton.setTitle("Update", for: .normal)
            colorGrid.checkMatchAndHighlight(with: (selectedProject?.color as? UIColor)!)

        } else {
            self.title = "Create A New Project"
        }
        
    }
    
    func addNavBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action:
            #selector(closeButtonTapped))
        self.navigationItem.rightBarButtonItem = cancelButton
        
    }
    
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func colorGridContraints() {
        view.addSubview(colorGrid)
        
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
            self.getProjectName.bottomAnchor.constraint(equalTo: self.colorGrid.topAnchor, constant: -30),
            self.getProjectName.widthAnchor.constraint(equalToConstant: 150.0),
            self.getProjectName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func addSaveButton() {
        view.addSubview(saveButton)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: self.colorGrid.bottomAnchor, constant: 40),
            self.saveButton.heightAnchor.constraint(equalToConstant: 48),
            self.saveButton.widthAnchor.constraint(equalToConstant: 150),
            self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func saveButtonTapped() {
        
        if selectedProject != nil { // To update/edit project
            selectedProject?.setValue(getProjectName.text, forKey: "name")
            if self.getColor != nil {
                selectedProject?.setValue(self.getColor, forKey: "color")
            }
            coreDataStack?.saveContext()
            dismiss(animated: true, completion: nil)
        }else { // To save new project
            let newProject = Project(context: coreDataStack!.managedContext)
            newProject.name = getProjectName.text
            newProject.color = getColor
            coreDataStack?.saveContext()
            dismiss(animated: true, completion: nil)
        }
    }
}
