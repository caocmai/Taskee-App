//
//  ViewController.swift
//  Taskee App
//
//  Created by Cao Mai on 6/28/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class ProjectsVC: UIViewController {
    
    var coreData = CoreDataStack()
    
    var projects = [Project]()
    
    var table: UITableView = {
        let newTable = UITableView()
        return newTable
    }()
    
    var sample = ["a", "s", "d", "d", "s"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureNavBar()
        
        
        
        
        self.fetchProjects()
        self.configureTable()
        
        
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "All Projects"
        let addButton = UIBarButtonItem(title: "New Project", style: .plain, target: self, action: #selector(addButtonTapped))
        
        self.navigationItem.rightBarButtonItem = addButton
        //        self.navigationItem.rightBarButtonItem?.title = "Done"
        
        
        
        //        let camera = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: Selector("btnOpenCamera"))
        //        self.navigationItem.rightBarButtonItem = camera
    }
    
    private func fetchProjects() {
        coreData.fetchPersistedData { (results) in
            switch results {
            case .success(let allProjects):
                self.projects = allProjects
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureTable() {
        self.table.frame = self.view.bounds
        self.view.addSubview(self.table)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.table.separatorStyle = .none
        
    }
    
    @objc func addButtonTapped(){
        print("hello")
        let newProject = Project(context: coreData.managedContext)
                newProject.name = "another"
                newProject.color = UIColor.color(red: 13, green: 7, blue: 126, alpha: 0.50)
                coreData.saveContext()
        table.reloadData()
    }
    
    
    
}


extension ProjectsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let project = projects[indexPath.row]
        cell.textLabel?.text = project.name
        cell.textLabel?.backgroundColor = project.color as? UIColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = TasksVC()
        destinationVC.selectedProject = projects[indexPath.row]
        destinationVC.coreData = coreData.managedContext
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    
}
