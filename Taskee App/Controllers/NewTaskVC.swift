//
//  NewTaskVC.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
// testing branch

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
    
    let taskImageView: UIImageView = {
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
        self.view.backgroundColor = .white
        setupEditUI()
        setupUI()
        datePickerToolbar()
        addDoneButtonOnKeyboard()
        UITextField.connectFields(fields: [setTitle, dateTextField]) // for better user experience when filling out forms
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 100 - keyboardSize.height
//        navigationController?.isNavigationBarHidden = true // This is preventing from moving screen properly when enable
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
        navigationController?.isNavigationBarHidden = false
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:38, y: 100, width: 244, height: 30))
        doneToolbar.barStyle = UIBarStyle.default
        
        let hide = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(closeKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: #selector(nextFieldTapped))
        
        doneToolbar.items = [hide, flexSpace, done]
        doneToolbar.sizeToFit()
        setTitle.inputAccessoryView = doneToolbar
    }
    
    @objc func closeKeyboard() {
        setTitle.resignFirstResponder()
    }
    
    @objc func nextFieldTapped() {
        dateTextField.becomeFirstResponder()
    }
    
    private func setupEditUI() {
        if taskToEdit != nil {
            setTitle.text = taskToEdit?.title
            taskImageView.image = UIImage(data: (taskToEdit?.taskImage)!)
            dateTextField.text = dateFormatter.string(from: (taskToEdit?.dueDate)!)
            self.title = "Edit \(taskToEdit?.title ?? "UnNamed")"
            saveButton.setTitle("Update", for: .normal)
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
        self.view.addSubview(setTitle)
        self.view.addSubview(dateTextField)
        self.view.addSubview(taskImageView)
        self.view.addSubview(saveButton)
        dateTextField.inputView = datePicker
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        taskImageView.addGestureRecognizer(singleTap)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            taskImageView.widthAnchor.constraint(equalToConstant: 150),
            taskImageView.heightAnchor.constraint(equalToConstant: 150),
            taskImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120)
            
            
        ])
        
        NSLayoutConstraint.activate([
            setTitle.topAnchor.constraint(equalTo: taskImageView.bottomAnchor, constant: 45),
            setTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
               setTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateTextField.topAnchor.constraint(equalTo: setTitle.bottomAnchor, constant: 45),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
               dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)
        ])
    
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 55),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
        ])
    }
    
    @objc func saveButtonTapped() {
        if !checkAreFieldsEmpty() {
            if taskToEdit != nil {
                taskToEdit?.setValue(setTitle.text, forKey: "title")
                if dateTextField.text != dateFormatter.string(from: (taskToEdit?.dueDate)!) {
                    taskToEdit?.setValue(datePicker.date, forKey: "dueDate")
                }
                taskToEdit?.setValue(taskImageView.image?.pngData(), forKey: "taskImage")
                coreDataStack?.saveContext()
            } else {
                createNewTask()
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkAreFieldsEmpty() -> Bool {
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
        } else {
            dateTextField.layer.borderWidth = 0
            dateTextField.layer.borderColor = UIColor.clear.cgColor
            dateTextField.borderStyle = .roundedRect
        }
        
        if setTitle.text != "" && dateTextField.text != "" {
            return false // This means all fields are filled
        }
        
        return true
    }
    
    private func datePickerToolbar() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:38, y: 100, width: 244, height: 30))
        doneToolbar.barStyle = UIBarStyle.default
        
        let hide = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(cancelButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonTapped))
        doneToolbar.items = [hide, flexSpace, done]
        doneToolbar.sizeToFit()
        dateTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func cancelButtonTapped(_ button: UIBarButtonItem?) {
        dateTextField.resignFirstResponder()
    }
    
    @objc func doneButtonTapped(_ button: UIBarButtonItem?) {
        dateTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateTextField.text = formatter.string(from: datePicker.date) // shows the date in UItexfield from datepicker
    }
    
    private func createNewTask() {
        let newTask = Task(context: (coreDataStack?.managedContext)!)
        newTask.dueDate = datePicker.date
        newTask.status = false
        newTask.title = setTitle.text
        newTask.taskImage = taskImageView.image!.pngData()
        newTask.parentProject = parentObject
        newTask.parentProject?.taskCount += 1
        newTask.parentProject?.projectStatus = "0Pending Tasks"
        coreDataStack?.saveContext()
    }

}

// - MARK: UIImagePickerControllerDelegate

extension NewTaskVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            taskImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
}

