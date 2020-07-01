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
            self.loadItems()
        }
    }
    var tasks = [Task]()
    var coreData: NSManagedObjectContext!
    var coredataSTack = CoreDataStack()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
//        let tasks = selectedProject?.projectTasks[0] as? Task
//        print(selectedProject?.projectTasks)
        self.configureTable()
        
        
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "\(selectedProject!.name ?? "Unnamed") Tasks"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped(){
        print("hello")
        let destinationVC = NewTaskVC()
        destinationVC.coreData = coreData
        destinationVC.parentObject = selectedProject
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
      
        
    }
    
    func configureTable() {
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
        self.taskTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(taskTable)
        self.taskTable.frame = view.bounds
        self.taskTable.separatorStyle = .none

        
    }
    
    func loadItems(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentProject.name MATCHES %@", selectedProject!.name!)
        

        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

    
        do {
            tasks = try coredataSTack.managedContext.fetch(request)
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
        cell.textLabel!.text = dateFormatter.string(from: tasks[indexPath.row].dueDate!)
        return cell
    }
    
    
}

