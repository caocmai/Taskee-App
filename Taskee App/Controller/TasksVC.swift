//
//  TasksVC.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class TasksVC: UIViewController {
    
    var selectedProject: Project? {
        didSet{
            self.title = selectedProject?.name
        }
    }
    var tasks = [Task]()
    
    let taskTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped(){
        print("hello")
    }
    
    func configureTable() {
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
        self.taskTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(taskTable)
        self.taskTable.frame = view.bounds
        self.taskTable.separatorStyle = .none

        
    }
    
    
}

extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    
}

