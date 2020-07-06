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
    
    var selectedProject: Project? {
        didSet{
//            self.loadItems()
        }
    }
    var tasks = [Task]()
    var managedContext: NSManagedObjectContext?
//    var coredataSTack = CoreDataStack()
    var testCD: CoreDataStack!
    
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
    
    var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSegmentControl()

        self.configureNavBar()
//        let tasks = selectedProject?.projectTasks[0] as? Task
//        print(selectedProject?.projectTasks)
        self.configureTable()
//        self.loadItems()
        test()
//        print("passed coredata", managedContext)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.loadItems()
        test()
        self.taskTable.reloadData()
    }
    
    func test() {
        testCD.fetchTasks(selectedProject: (selectedProject?.name)!) { (restuls) in
            switch restuls {
            case .success(let yes):
                self.tasks = yes
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addSegmentControl() {
       let segmentItems = ["Pending", "Finished"]
    segmentControl = UISegmentedControl(items: segmentItems)
//       control.frame = CGRect(x: 10, y: 250, width: (self.view.frame.width - 20), height: 50)
       segmentControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
       segmentControl.selectedSegmentIndex = 1
       view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            segmentControl.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20.0),
            segmentControl.heightAnchor.constraint(equalToConstant: 50.0)
            
        ])
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
             // First segment tapped
            print("one")
          case 1:
             // Second segment tapped
            print("two")
          default:
          break
       }
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "\(selectedProject!.name ?? "Unnamed") Tasks"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addTaskTapped(){
//        let newTask = Task(context: self.coreData)
//        newTask.dueDate = Date()
//        newTask.status = false
//        newTask.title = "Other task"
//        newTask.taskImage = UIImage(named: "mango")?.pngData()
//        newTask.parentProject = self.selectedProject
//        testCD.saveContext()
        
        let destinationVC = NewTaskVC()
        destinationVC.coreData = testCD.managedContext
        destinationVC.parentObject = selectedProject
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
      
        
    }
    
    func configureTable() {
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
        self.taskTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(taskTable)
//        self.taskTable.frame = view.bounds
        self.taskTable.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            self.taskTable.topAnchor.constraint(equalTo: self.segmentControl.bottomAnchor),
            self.taskTable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.taskTable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.taskTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])

        
    }
    
    func loadItems(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentProject.name MATCHES %@", selectedProject!.name!)
        

        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

    
        do {
            tasks = try managedContext!.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        taskTable.reloadData()
        
    }
    
    
}

extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel!.text = dateFormatter.string(from: tasks[indexPath.row].dueDate!)
        let task = tasks[indexPath.row]
        cell.textLabel!.text = task.title
        cell.accessoryType = task.status ? .checkmark : .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].status = !tasks[indexPath.row].status
        tableView.deselectRow(at: indexPath, animated: true)

        testCD.saveContext()
        taskTable.reloadData()
//        test()
        
    }
    
    
}

