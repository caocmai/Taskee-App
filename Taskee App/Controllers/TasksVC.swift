//
//  TasksVC.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
// testing branch

import UIKit
import CoreData

class TasksVC: UIViewController {
    
    var selectedProject: Project?
    var tasks = [Task]()
    var coreDataStack: CoreDataStack!
    let searchController = UISearchController()
    var segmentControl: UISegmentedControl!
    var sortByString = "dueDate"
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    lazy var taskTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        table.separatorStyle = .none
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "\(selectedProject!.name ?? "Unnamed") Tasks"
        
        addSegmentControl()
//        configureNavBar()
        configureTable()
        //        getPendingTasks()
        // For context menu to have preview
        let interaction = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(interaction)
        addNotifyEmptyTableLabel()

    }
    
    // fetch item right after user adds task, to get it to show/update
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       determineSegmentToShow()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         // determine proper sections before view disappears
        determineProjectSection()
    }
    
    private func determineSegmentToShow() {
        if selectedProject?.projectStatus == "2Completed Projects" { // to show completed tasks when none pending tasks
                   segmentControl.selectedSegmentIndex = 1
                   getFinshedTasks()
                   self.navigationItem.rightBarButtonItems = configureNavBar(segment: 1)
               } else {
                   segmentControl.selectedSegmentIndex = 0
                   getPendingTasks()
                   self.navigationItem.rightBarButtonItems = configureNavBar(segment: 0)
               }
    }
    
    private func setupUIForEmptyPendingTasks(withDuration time: Double) {
        notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        notifyEmptyTableLabel.text = "No Pending Tasks"
        notifyEmptyTableLabel.isHidden = false
        
        UIView.animate(withDuration: time, delay: 0.0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        self.notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 1, y: 1)},
                       completion: nil)
    }
    
    private func setupUIForEmptyCompletedTasks(withDuration time: Double) {
        notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        notifyEmptyTableLabel.text = "No Completed Tasks"
        notifyEmptyTableLabel.isHidden = false
        
        UIView.animate(withDuration: time, delay: 0.0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        self.notifyEmptyTableLabel.transform = CGAffineTransform(scaleX: 1, y: 1)},
                       completion: nil)
    }
    
    private func addNotifyEmptyTableLabel() {
        self.view.addSubview(notifyEmptyTableLabel)
        NSLayoutConstraint.activate([
            notifyEmptyTableLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            notifyEmptyTableLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func getPendingTasks() {
        let projectStatusPredicate = NSPredicate(format: "isCompleted = false")
        coreDataStack.fetchTasks(sortBy: sortByString, predicate: projectStatusPredicate, selectedProject: (selectedProject)!) { results in
            switch results {
            case .success(let tasks):
                self.tasks = tasks
                self.taskTable.reloadData()
                if tasks.isEmpty {
                    self.setupUIForEmptyPendingTasks(withDuration: 1.10)
                } else {
                    self.notifyEmptyTableLabel.isHidden = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getFinshedTasks() {
        let projectStatusPredicate = NSPredicate(format: "isCompleted = true")
        coreDataStack.fetchTasks(sortBy: sortByString, predicate: projectStatusPredicate, selectedProject: (selectedProject)!) { results in
            switch results {
            case .success(let tasks):
                self.tasks = tasks
                self.taskTable.reloadData()
                if tasks.isEmpty {
                    self.setupUIForEmptyCompletedTasks(withDuration: 1.10)
                } else {
                    self.notifyEmptyTableLabel.isHidden = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addSegmentControl() {
        let segmentItems = ["Pending", "Completed"]
        segmentControl = UISegmentedControl(items: segmentItems)
        segmentControl.addTarget(self, action: #selector(segmentControlTapped(_:)), for: .valueChanged)
        
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            segmentControl.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20.0),
            segmentControl.heightAnchor.constraint(equalToConstant: 48.0)
            
        ])
    }
    
    // what happens when user taps on the segment
    @objc func segmentControlTapped(_ segmentedControl: UISegmentedControl) {
        notifyEmptyTableLabel.isHidden = true
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:  // First segment tapped
            getPendingTasks()
            self.navigationItem.rightBarButtonItems = configureNavBar(segment: 0)
        case 1:  // Second segment tapped
            getFinshedTasks()
            self.navigationItem.rightBarButtonItems = configureNavBar(segment: 1)
        default:
            break
        }
    }
    
    
    private func configureNavBar(segment: Int) -> [UIBarButtonItem]{
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        let resetFinishedTasks = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFinishedTasksTapped))
        
        if segment == 0 {
            return [addButton, self.editButtonItem]
        } else {
            return [addButton, self.editButtonItem, resetFinishedTasks]
        }

    }
    
    @objc func resetFinishedTasksTapped() {
        
        let refreshAlert = UIAlertController(title: "Reset All Finished Tasks", message: "Caution: Will revert ALL completed tasks as pending again", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            for task in self.tasks {
                if task.isCompleted {
                    task.isCompleted = !task.isCompleted
                }
            }
            self.determineProjectSection()
            self.coreDataStack.saveContext()
            self.getFinshedTasks()
            self.taskTable.reloadData()
            
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Reset is cancled")
          }))

        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    // This method is needed for edit button in navbar to work
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        taskTable.setEditing(editing, animated: true)
    }
    
    @objc func addTaskTapped(){
        let destinationVC = NewTaskVC()
        destinationVC.coreDataStack = coreDataStack
        destinationVC.parentObject = selectedProject
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func configureTable() {
        self.view.addSubview(taskTable)
        // Refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        taskTable.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            taskTable.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            taskTable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            taskTable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            taskTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    @objc func refresh() {
        taskTable.refreshControl?.endRefreshing()
        if segmentControl.selectedSegmentIndex == 0 {
            getPendingTasks()
        } else {
            getFinshedTasks()
        }
        taskTable.reloadData()
    }
    
    
}

// - MARK: UITableView

extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        let task = tasks[indexPath.row]
        cell.configureUIForTask(with: task)
        //        cell.accessoryType = task.status ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        selectedTask.isCompleted = !selectedTask.isCompleted
        selectedTask.dateCompleted = Date()
        
        guard let taskTitle = selectedTask.title, let taskDueDate = selectedTask.dueDate, let taskID = selectedTask.taskID, let taskImage = selectedTask.taskImage else {return}
        
        if !selectedTask.isCompleted {
            // not sure if I should keep this
            NotificationHelper.addNotification(project: (selectedTask.parentProject?.name!)!, about: taskTitle, at: taskDueDate, alertBeforeSecs: 3600, uniqueID: taskID.uuidString, image: UIImage(data: taskImage)!)
        } else {
            NotificationHelper.removeTaskFromNotification(id: taskID)
        }
        
        //        if selectedTask.status { // decrement or increment to keep track of task  count
        //            selectedTask.parentProject?.taskCount -= 1
        //        } else {
        //            selectedTask.parentProject?.taskCount += 1
        //        }
        //
        //        if selectedTask.parentProject?.taskCount == 0 { // changing the status
        //            selectedTask.parentProject?.projectStatus = "2Tasks Completed"
        //        } else {
        //            selectedTask.parentProject?.projectStatus = "0Pending Tasks"
        //        }
        determineProjectSection()
        //        coreDataStack.saveContext()
        taskTable.reloadData() // To get checkmark to show
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: // handling the delete action
            let task = tasks[indexPath.row]
            NotificationHelper.removeTaskFromNotification(id: task.taskID!)
            deleteTask(with: task, at: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private func deleteTask(with task: Task, at indexPath: IndexPath) {
        coreDataStack.managedContext.delete(task)
        tasks.remove(at: indexPath.row)
        taskTable.deleteRows(at: [indexPath], with: .fade)
        determineProjectSection()
    }
    
    private func determineProjectSection() {
        var pendingTaskCount = 0
        
        for task in selectedProject!.projectTasks! {
            if (task as! Task).isCompleted == false {
                pendingTaskCount += 1
            }
        }
        
        if selectedProject!.projectTasks?.count == 0 {
            selectedProject?.projectStatus = "1New Projects"
        }
        else if pendingTaskCount == 0 {
            selectedProject!.projectStatus = "2Completed Projects"
        } else {
            selectedProject!.projectStatus = "0Active Projects"
        }
        
        coreDataStack.saveContext()
    }
    
}

// - MARK: UIContextMenuInteractionDelegate

extension TasksVC: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            let preview = PreviewVC()
            let previewTask = self.tasks[indexPath.row]
            preview.configureTask(with: previewTask)
            return preview
            
        }) { _ -> UIMenu? in
            let edit = UIAction(title: "Edit...", image: nil) { action in
                self.dismiss(animated: false, completion: nil)
                let editVC = NewTaskVC()
                editVC.taskToEdit = self.tasks[indexPath.row]
                editVC.coreDataStack = self.coreDataStack
                self.navigationController?.pushViewController(editVC, animated: true)
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: .none, discoverabilityTitle: .none, attributes: .destructive, state: .off) { (_) in
                let task = self.tasks[indexPath.row]
                NotificationHelper.removeTaskFromNotification(id: task.taskID!)
                self.deleteTask(with: task, at: indexPath)
            }
            
            let sortByDate = UIAction(title: "Sort By Name") { (_) in
                self.sortByString = "title"
                self.determineSegmentToShow()
                
            }
            
            return UIMenu(title: "Action", children: [edit, sortByDate, delete])
        }
        return configuration
    }
    
}
