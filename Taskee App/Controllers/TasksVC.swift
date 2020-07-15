//
//  TasksVC.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit
import CoreData

class TasksVC: UIViewController {
    
    
    var selectedProject: Project?
    var tasks = [Task]()
    //    var managedContext: NSManagedObjectContext?
    //    var coredataSTack = CoreDataStack()
    var coreDataStack: CoreDataStack!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    let taskTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let notifyEmptyTableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        return label
    }()
    
    var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSegmentControl()
        
        self.configureNavBar()
        //        let tasks = selectedProject?.projectTasks[0] as? Task
        //        print(selectedProject?.projectTasks)
        self.configureTable()
        //        self.loadItems()
        getPendingTasks()
        //        print("passed coredata", managedContext)
        let interaction = UIContextMenuInteraction(delegate: self)
        view.addInteraction(interaction)
        addNotifyEmptyTableLabel()
        
        
        
    }
    
    
    
    // fetch the items before user gets a chance to tap on a segment
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.loadItems()
        if segmentControl.selectedSegmentIndex == 0 {
            getPendingTasks()
            
            
            //            if tasks.isEmpty {
            //
            //                setupUIForEmptyPendingTasks(withDuration: 1.10)
            //            }
            
        } else {
            getFinshedTasks()
            //            notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            //            if tasks.isEmpty {
            //                setupUIForEmptyCompletedTasks(withDuration: 1.10)
            //            }
            //            self.taskTable.reloadData()
        }
    }
    
    func setupUIForEmptyPendingTasks(withDuration time: Double) {
        notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        notifyEmptyTableLabel.text = "No Pending Tasks"
        notifyEmptyTableLabel.isHidden = false
        
        UIView.animate(withDuration: time, delay: 0.0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        self.notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 1, y: 1)},
                       completion: nil)
    }
    
    func setupUIForEmptyCompletedTasks(withDuration time: Double) {
        notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        notifyEmptyTableLabel.text = "No Completed Tasks"
        notifyEmptyTableLabel.isHidden = false
        
        UIView.animate(withDuration: time, delay: 0.0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        self.notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 1, y: 1)},
                       completion: nil)
    }
    
    func addNotifyEmptyTableLabel() {
        self.view.addSubview(notifyEmptyTableLabel)
        NSLayoutConstraint.activate([
            notifyEmptyTableLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            notifyEmptyTableLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        notifyEmptyTableLabel.isHidden = true
        
        //        notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    
    func getPendingTasks() {
        let projectStatusPredicate = NSPredicate(format: "status = false")
        coreDataStack.fetchTasks(predicate: projectStatusPredicate, selectedProject: (selectedProject?.name)!) { results in
            switch results {
            case .success(let tasks):
                self.tasks = tasks
                self.taskTable.reloadData()
                if tasks.isEmpty {
                    self.setupUIForEmptyPendingTasks(withDuration: 1.10)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFinshedTasks() {
        let projectStatusPredicate = NSPredicate(format: "status = true")
        coreDataStack.fetchTasks(predicate: projectStatusPredicate, selectedProject: (selectedProject?.name)!) { results in
            switch results {
            case .success(let tasks):
                self.tasks = tasks
                self.taskTable.reloadData()
                if tasks.isEmpty {
                    self.setupUIForEmptyCompletedTasks(withDuration: 1.10)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addSegmentControl() {
        let segmentItems = ["Pending", "Completed"]
        segmentControl = UISegmentedControl(items: segmentItems)
        //       control.frame = CGRect(x: 10, y: 250, width: (self.view.frame.width - 20), height: 50)
        segmentControl.addTarget(self, action: #selector(segmentControlTapped(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            segmentControl.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20.0),
            segmentControl.heightAnchor.constraint(equalToConstant: 45.0)
            
        ])
    }
    
    // what happens when user taps on the segment
    @objc func segmentControlTapped(_ segmentedControl: UISegmentedControl) {
        notifyEmptyTableLabel.isHidden = true
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:  // First segment tapped
            getPendingTasks()
            //            if tasks.isEmpty{
            //                setupUIForEmptyPendingTasks(withDuration: 1.0)
        //            }
        case 1:  // Second segment tapped
            getFinshedTasks()
            
            //            if tasks.isEmpty {
            //                setupUIForEmptyCompletedTasks(withDuration: 1.0)
        //            }
        default:
            break
        }
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "\(selectedProject!.name ?? "Unnamed") Tasks"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        self.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem]
        //        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    
    // This method is needed for edit button in navbar to work
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        taskTable.setEditing(editing, animated: true)
    }
    
    @objc func addTaskTapped(){
        let destinationVC = NewTaskVC()
        //        destinationVC.managedContext = coreDataStack.managedContext
        destinationVC.coreDataStack = coreDataStack
        destinationVC.parentObject = selectedProject
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func configureTable() {
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
        self.taskTable.register(ProjectCell.self, forCellReuseIdentifier: ProjectCell.identifier)
        self.view.addSubview(taskTable)
        //        self.taskTable.frame = view.bounds
        self.taskTable.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged
        )
        self.taskTable.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            self.taskTable.topAnchor.constraint(equalTo: self.segmentControl.bottomAnchor),
            self.taskTable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.taskTable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.taskTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    @objc func refresh() {
        self.taskTable.refreshControl?.endRefreshing()
        if segmentControl.selectedSegmentIndex == 0 {
            getPendingTasks()
            setupUIForEmptyPendingTasks(withDuration: 1.10)
            
        } else {
            getFinshedTasks()
            setupUIForEmptyCompletedTasks(withDuration: 1.10)
        }
        
        self.taskTable.reloadData()
        
    }
    
}

extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCell.identifier, for: indexPath) as! ProjectCell
        //        cell.textLabel!.text = dateFormatter.string(from: tasks[indexPath.row].dueDate!)
        let task = tasks[indexPath.row]
        
        
        cell.configureUIForTask(with: task)
        cell.accessoryType = task.status ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].status = !tasks[indexPath.row].status
        //        tasks[indexPath.row].setValue(Date(), forKey: "dueDate")
        
        coreDataStack.saveContext()
        taskTable.reloadData() // To get checkmark to show
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            let task = tasks[indexPath.row]
            self.coreDataStack.managedContext.delete(task)
            self.tasks.remove(at: indexPath.row)
            self.taskTable.deleteRows(at: [indexPath], with: .fade)
            self.coreDataStack.saveContext()
            
            // handling the delete action
            
        default:
            break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    //    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //
    //        let habitToSwap = self.tasks[sourceIndexPath.row]
    //        self.tasks.remove(at: sourceIndexPath.row)
    //        self.tasks.insert(habitToSwap, at: destinationIndexPath.row)
    //        self.coreDataStack.saveContext()
    //
    //    }
}


extension TasksVC: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            let preview = PreviewViewController()
            let object = self.tasks[indexPath.row]
            preview.taskTitleLabel.text = object.title //Testing
            preview.imageView.image = UIImage(data: object.taskImage!)
            preview.taskDueDateLabel.text = self.dateFormatter.string(from: object.dueDate!)
            return preview
        }) { _ -> UIMenu? in
            let action = UIAction(title: "Edit...", image: nil) { action in
                self.dismiss(animated: false, completion: nil)
                let editVC = NewTaskVC()
                editVC.taskToEdit = self.tasks[indexPath.row]
                editVC.coreDataStack = self.coreDataStack
                self.navigationController?.pushViewController(editVC, animated: true)
                
            }
            return UIMenu(title: "Action", children: [action])
        }
        return configuration
    }
    
}


// currently not used
extension String {
    
    /// Apply strike font on text
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
}
