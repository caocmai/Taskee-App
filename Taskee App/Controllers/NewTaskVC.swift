//
//  NewTaskVC.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit
import CoreData

class NewTaskVC: UIViewController {
    var datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    
    //    var managedContext: NSManagedObjectContext!
    
    let setTitle: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Task Title"
        textField.borderStyle = .roundedRect
        textField.tag = 0
        //        textField.keyboardType = .default //keyboard type
        
        return textField
    }()
    
    var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Done By"
        textField.tag = 1
        //        textField.keyboardType = .default
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
        //        image.layer.borderColor = UIColor.color(red: 123, green: 12, blue: 12)?.cgColor
        //        image.layer.borderWidth = 5
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
        //        createToolbar()
        datePickerToolbar()
        //        setTitle.delegate = self
        //        dateTextField.delegate = self
        addDoneButtonOnKeyboard()
        UITextField.connectFields(fields: [setTitle, dateTextField])
        
        
        
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
        
        //        formatter.dateStyle = .short
        
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
            //            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            self.setTitle.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 45),
            self.setTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateTextField.topAnchor.constraint(equalTo: setTitle.bottomAnchor, constant: 40),
            
        ])
        
        saveButton.alpha = 0.5
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
            self.saveButton.alpha = 1.0
        },completion: nil)
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 45),
            self.saveButton.heightAnchor.constraint(equalToConstant: 48),
            self.saveButton.widthAnchor.constraint(equalToConstant: 150),
            self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func saveButtonTapped() {
        
        //        let newTask = Task(context: self.coreData)
        //        newTask.dueDate = datePicker.date
        //        newTask.status = false
        //        newTask.title = setTitle.text
        //        newTask.taskImage = imageView.image!.pngData()
        //        newTask.parentProject = self.parentObject
        //        self.navigationController?.popViewController(animated: true)
        //
        //        do{
        //            try self.coreData.save()
        //        }catch{
        //            print("error")
        //        }
        
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
    
    //    func createToolbar() {
    //        let pickerToolbar: UIToolbar = UIToolbar(frame: CGRect(x:38, y: 100, width: 244, height: 30))
    //        pickerToolbar.autoresizingMask = .flexibleHeight // This or the bottom works the same
    //        //        pickerToolbar.sizeToFit()
    //        //add buttons
    //        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action:
    //            #selector(cancelButtonTapped))
    //        //        cancelButton.tintColor = UIColor.white
    //        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    //        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
    //            #selector(doneButtonTapped))
    //        //        doneButton.tintColor = UIColor.white
    //
    //        //add the items to the toolbar
    //        pickerToolbar.items = [cancelButton, flexSpace, doneButton]
    //        self.dateTextField.inputAccessoryView = pickerToolbar
    //    }
    
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
        
        //        var items = [UIBarButtonItem]()
        //        items.append(hide)
        //        items.append(flexSpace)
        //        items.append(done)
        //
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
        //        do {
        //            try managedContext.save()
        //            print("saved")
        //        }
        //        catch{
        //            print(error)
        //        }
    }
    
    //    @objc func datePickerSelected() {
    //        dateTextField.text =  datePicker.date.description
    //        let newTask = Task(context: self.coreData)
    //        newTask.dueDate = datePicker.date
    //        newTask.status = false
    //        newTask.title = "Other task"
    //        newTask.taskImage = UIImage(named: "mango")?.pngData()
    //        newTask.parentProject = self.parentObject
    //
    //        do {
    //            try coreData.save()
    //            print("saved")
    //        }
    //        catch{
    //            print(error)
    //        }
    //    }
    
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

