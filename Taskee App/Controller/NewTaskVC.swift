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
    var dateTextField = UITextField()
    var parentObject: Project!
    var coreData: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
//        createToolbar()
        addDoneButtonOnKeyboard()
        
        
    }
    
    private func setupUI() {
        view.addSubview(dateTextField)
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.inputView = datePicker
        dateTextField.placeholder = "PICk time"
        
        NSLayoutConstraint.activate([
            dateTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func createToolbar() {
        let pickerToolbar: UIToolbar = UIToolbar(frame: CGRect(x:38, y: 100, width: 244, height: 30))
        pickerToolbar.autoresizingMask = .flexibleHeight // This or the bottom works the same
//        pickerToolbar.sizeToFit()
        //add buttons
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action:
            #selector(cancelBtnTapped))
//        cancelButton.tintColor = UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
            #selector(doneBtnTapped))
//        doneButton.tintColor = UIColor.white
        
        //add the items to the toolbar
        pickerToolbar.items = [cancelButton, flexSpace, doneButton]
        self.dateTextField.inputAccessoryView = pickerToolbar
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:38, y: 100, width: 244, height: 30))
        doneToolbar.barStyle = UIBarStyle.default

        let hide = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(cancelBtnTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        let done: UIBarButtonItem = UIBarButtonItem(title: "Check", style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelBtnTapped))

//        var items = [UIBarButtonItem]()
//        items.append(hide)
//        items.append(flexSpace)
//        items.append(done)
//
        doneToolbar.items = [hide, flexSpace, done]
        doneToolbar.sizeToFit()
        self.dateTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func cancelBtnTapped(_ button: UIBarButtonItem?) {
        dateTextField.resignFirstResponder()
    }
    
    @objc func doneBtnTapped(_ button: UIBarButtonItem?) {
        dateTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    private func createNewTask() {
        
        let newTask = Task(context: self.coreData)
        newTask.dueDate = Date()
        newTask.status = false
        newTask.title = "A new task"
        newTask.taskImage = UIImage(named: "mango")?.pngData()
        newTask.parentProject = self.parentObject
        
        do {
            try coreData.save()
            print("saved")
        }
        catch{
            print(error)
        }
    }
    
    @objc func datePickerSelected() {
        dateTextField.text =  datePicker.date.description
        let newTask = Task(context: self.coreData)
        newTask.dueDate = datePicker.date
        newTask.status = false
        newTask.title = "Other task"
        newTask.taskImage = UIImage(named: "mango")?.pngData()
        newTask.parentProject = self.parentObject
        
        do {
            try coreData.save()
            print("saved")
        }
        catch{
            print(error)
        }
    }
    
}
