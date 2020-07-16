//
//  NewTaskVC.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit
import CoreData

class NewTaskVC: UIViewController, UITextFieldDelegate {
    
    var datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    
    let setTitle: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Task Title"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.tag = 0
        return textField
    }()
    
    var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Done By"
        textField.textAlignment = .center
        textField.tag = 1
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
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "no item image")
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 75
        image.layer.masksToBounds = true
        return image
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        return dateFormat
    }()
    
    var parentObject: Project!
    var taskToEdit: Task?
    var coreDataStack: CoreDataStack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupEditUI()
        setupUI()
        datePickerToolbar()
        addDoneButtonOnKeyboard()
        UITextField.connectFields(fields: [setTitle, dateTextField])
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 100 - keyboardSize.height
//        self.navigationController?.isNavigationBarHidden = true // This is preventing from moving  screen properly
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:38, y: 100, width: 244, height: 30))
        doneToolbar.barStyle = UIBarStyle.default
        
        let hide = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(closeKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: #selector(nextFieldTapped))
        
        doneToolbar.items = [hide, flexSpace, done]
        doneToolbar.sizeToFit()
        self.setTitle.inputAccessoryView = doneToolbar
    }
    
    @objc func closeKeyboard() {
        self.setTitle.resignFirstResponder()
    }
    
    @objc func nextFieldTapped() {
        self.dateTextField.becomeFirstResponder()
        
    }
    
    func setupEditUI() {
        if taskToEdit != nil {
            setTitle.text = taskToEdit?.title
            imageView.image = UIImage(data: (taskToEdit?.taskImage)!)
            dateTextField.text = dateFormatter.string(from: (taskToEdit?.dueDate)!)
            self.title = "Edit \(taskToEdit?.title ?? "UnNamed")"
            self.saveButton.setTitle("Update", for: .normal)
            
        } else {
            self.title = "Create A New Task"
        }
    }
    
    @objc func imageViewTapped() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    private func setupUI() {
        view.addSubview(setTitle)
        view.addSubview(dateTextField)
        view.addSubview(imageView)
        view.addSubview(saveButton)
        dateTextField.inputView = datePicker
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(singleTap)
        
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 150),
            self.imageView.heightAnchor.constraint(equalToConstant: 150),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -120)
        ])
        
        NSLayoutConstraint.activate([
            setTitle.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 45),
            setTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            setTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80),
               setTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80)
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateTextField.topAnchor.constraint(equalTo: setTitle.bottomAnchor, constant: 45),
            dateTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
               dateTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100)
        ])
    
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 45),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45),
            saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -45),
        ])
    }
    
    @objc func saveButtonTapped() {
        if !checkForEmptyFields() {
            if taskToEdit != nil {
                taskToEdit?.setValue(setTitle.text, forKey: "title")
                if self.dateTextField.text != dateFormatter.string(from: (taskToEdit?.dueDate)!) {
                    taskToEdit?.setValue(self.datePicker.date, forKey: "dueDate")
                }
                taskToEdit?.setValue(imageView.image?.pngData(), forKey: "taskImage")
                coreDataStack?.saveContext()
            } else {
                createNewTask()
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkForEmptyFields() -> Bool {
        if setTitle.text == "" {
            setTitle.layer.borderWidth = 2
            setTitle.layer.cornerRadius = 7
            setTitle.layer.borderColor = UIColor.red.cgColor
            setTitle.placeholder = "Needs Title!"
        } else {
            setTitle.layer.borderWidth = 0
            setTitle.layer.borderColor = UIColor.clear.cgColor
            setTitle.borderStyle = .roundedRect
        }
        
        if dateTextField.text == "" {
            dateTextField.layer.borderWidth = 2
            dateTextField.layer.cornerRadius = 7
            dateTextField.layer.borderColor = UIColor.red.cgColor
            dateTextField.placeholder = "Needs Date!"
        }else {
            dateTextField.layer.borderWidth = 0
            dateTextField.layer.borderColor = UIColor.clear.cgColor
            dateTextField.borderStyle = .roundedRect
        }
        
        if setTitle.text != "" && dateTextField.text != "" {
            return false
        }
        
        return true
    }
    
    func datePickerToolbar() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:38, y: 100, width: 244, height: 30))
        doneToolbar.barStyle = UIBarStyle.default
        
        let hide = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(cancelButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonTapped))
        doneToolbar.items = [hide, flexSpace, done]
        doneToolbar.sizeToFit()
        self.dateTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func cancelButtonTapped(_ button: UIBarButtonItem?) {
        dateTextField.resignFirstResponder()
    }
    
    @objc func doneButtonTapped(_ button: UIBarButtonItem?) {
        dateTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    private func createNewTask() {
        let newTask = Task(context: (self.coreDataStack?.managedContext)!)
        newTask.dueDate = datePicker.date
        newTask.status = false
        newTask.title = setTitle.text
        newTask.taskImage = imageView.image!.pngData()
        newTask.parentProject = self.parentObject
        coreDataStack?.saveContext()
    }

}


extension NewTaskVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
}

