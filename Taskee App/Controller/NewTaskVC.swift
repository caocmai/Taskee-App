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
    var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Date Date"
        return textField
    }()
    //    var managedContext: NSManagedObjectContext!
    
    let setTitle: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Task Title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "no item image")
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
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
        
        
    }
    
    func setupEditUI() {
        
        //        formatter.dateStyle = .short
        
        if taskToEdit != nil {
            setTitle.text = taskToEdit?.title
            imageView.image = UIImage(data: (taskToEdit?.taskImage)!)
            dateTextField.text = dateFormatter.string(from: (taskToEdit?.dueDate)!)
        }
    }
    
    @objc func imageViewTapped() {
        print("Imageview Clicked")
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
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150)
        ])
        
        NSLayoutConstraint.activate([
            self.setTitle.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 4)
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
        //
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
