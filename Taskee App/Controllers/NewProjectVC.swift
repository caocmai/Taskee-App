//
//  NewProjectVC.swift
//  Taskee App
//
//  Created by Cao Mai on 7/5/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class NewProjectVC: UIViewController, ButtonBackgroundColorDelegate {
    
    var selectedProject: Project?
    let colorGrid = ColorGrid()
    var coreDataStack: CoreDataStack?
    var getColorFromColorGrid: UIColor? = nil

    let setProjectName: UITextField = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupColorGrid()
        editProjectSetup()
        addProjectName()
        addSaveButton()
        addNavBar()
        // this improves user experience with filling out forms(UItexfield)
        UITextField.connectFields(fields: [setProjectName])

    }
    
    func getButtonColor(buttonColor: UIColor) {
        self.view.backgroundColor = buttonColor
        self.getColorFromColorGrid = buttonColor
    }
    
    private func editProjectSetup(){
        if selectedProject != nil {
            setProjectName.text = selectedProject?.name
            getColorFromColorGrid = selectedProject?.color as? UIColor
            view.backgroundColor = selectedProject?.color as? UIColor
            self.title = "Edit \(selectedProject?.name ?? "Unnamed")"
            self.saveButton.setTitle("Update", for: .normal)
            colorGrid.checkMatchAndHighlight(with: (selectedProject?.color as? UIColor)!)
        } else {
            self.title = "Create A New Project"
        }
    }
    
    private func addNavBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action:
            #selector(closeButtonTapped))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupColorGrid() {
        view.addSubview(colorGrid)
        colorGrid.delegate = self
        
        NSLayoutConstraint.activate([
            self.colorGrid.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.colorGrid.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.colorGrid.heightAnchor.constraint(equalToConstant: self.view.frame.width / 1.65),
            self.colorGrid.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.65)
        ])
    }
    
    private func addProjectName() {
        view.addSubview(setProjectName)
        
        NSLayoutConstraint.activate([
            self.setProjectName.bottomAnchor.constraint(equalTo: self.colorGrid.topAnchor, constant: -50),
            self.setProjectName.widthAnchor.constraint(equalToConstant: 180.0),
            self.setProjectName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func addSaveButton() {
        view.addSubview(saveButton)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: self.colorGrid.bottomAnchor, constant: 70),
            self.saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45),
            self.saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -45),
            self.saveButton.heightAnchor.constraint(equalToConstant: 48)
//            self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func checkAreFieldsEmpty() -> Bool {
        if setProjectName.text == "" {
            setProjectName.layer.borderWidth = 2
            setProjectName.layer.cornerRadius = 7
            setProjectName.layer.borderColor = UIColor.red.cgColor
            setProjectName.placeholder = "Needs Title!"
        } else {
            setProjectName.layer.borderWidth = 0
            setProjectName.layer.borderColor = UIColor.clear.cgColor
            setProjectName.borderStyle = .roundedRect
        }
        
        if getColorFromColorGrid == nil {
            let alert = UIAlertController(title: "Select a Color!", message: "Project needs a color to better differentiate between projects", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if setProjectName.text != "" && getColorFromColorGrid != nil {
            return false // This means all fields are filled
        }
        
        return true
    }
    
    
    @objc func saveButtonTapped() {
        if !checkAreFieldsEmpty() {
            if selectedProject != nil { // To update/edit project
                selectedProject?.setValue(setProjectName.text, forKey: "name")
                if self.getColorFromColorGrid != nil {
                    selectedProject?.setValue(self.getColorFromColorGrid, forKey: "color")
                }
                coreDataStack?.saveContext()
            }else { // To save new project
                let newProject = Project(context: coreDataStack!.managedContext)
                newProject.name = setProjectName.text
                newProject.color = getColorFromColorGrid
                coreDataStack?.saveContext()
            }
            dismiss(animated: true, completion: nil)
        }
    }
}
