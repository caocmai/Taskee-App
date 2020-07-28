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
        configureNavBar()
        configureTable()
        getPendingTasks()
        // For context menu to have preview
        let interaction = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(interaction)
        addNotifyEmptyTableLabel()
    }
    
    // fetch the items before user gets a chance to tap on a segment
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if segmentControl.selectedSegmentIndex == 0 {
            getPendingTasks()
        } else {
            getFinshedTasks()
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
        let projectStatusPredicate = NSPredicate(format: "status = false")
        coreDataStack.fetchTasks(predicate: projectStatusPredicate, selectedProject: (selectedProject)!) { results in
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
        let projectStatusPredicate = NSPredicate(format: "status = true")
        coreDataStack.fetchTasks(predicate: projectStatusPredicate, selectedProject: (selectedProject)!) { results in
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
        segmentControl.selectedSegmentIndex = 0
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
        case 1:  // Second segment tapped
            getFinshedTasks()
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
        taskTable.delegate = self
        taskTable.dataSource = self
        taskTable.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        self.view.addSubview(taskTable)
        taskTable.separatorStyle = .none
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
        self.taskTable.refreshControl?.endRefreshing()
        if segmentControl.selectedSegmentIndex == 0 {
            getPendingTasks()
        } else {
            getFinshedTasks()
        }
        self.taskTable.reloadData()
    }
    
}

// - MARK: UITableView

extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        let task = tasks[indexPath.row]
        cell.configureUIForTask(with: task)
        cell.accessoryType = task.status ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].status = !tasks[indexPath.row].status
        tasks[indexPath.row].setValue(Date(), forKey: "dueDate")
        coreDataStack.saveContext()
        taskTable.reloadData() // To get checkmark to show
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: // handling the delete action
            let task = tasks[indexPath.row]
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
        coreDataStack.saveContext()
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

// - MARK: UIContextMenuInteractionDelegate

extension TasksVC: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
            let preview = PreviewVC()
            let object = self.tasks[indexPath.row]
            preview.taskTitleLabel.text = object.title
            preview.imageView.image = UIImage(data: object.taskImage!)
            preview.taskDueDateLabel.text = object.status ? "Completed on \(self.dateFormatter.string(from: object.dueDate!))" : "Due by \(self.dateFormatter.string(from: object.dueDate!))"
            preview.taskDueDateLabel.textColor = object.status ? #colorLiteral(red: 0.2980392157, green: 0.7843137255, blue: 0.262745098, alpha: 1) : .black
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
                print("del")
                let task = self.tasks[indexPath.row]
                self.deleteTask(with: task, at: indexPath)
            }
            
            return UIMenu(title: "Action", children: [edit, delete])
        }
        return configuration
    }
    
}
