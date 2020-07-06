//
//  ViewController.swift
//  Taskee App
//
//  Created by Cao Mai on 6/28/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit
import CoreData

class ProjectsVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    var coreDataStack = CoreDataStack()
    
    var testCDStack: NSManagedObjectContext?
    
    var projects = [Project]()
    
    var table: UITableView = {
        let newTable = UITableView()
        return newTable
    }()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(Project.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self // Use to detect changes and don't have to manually reload data
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureNavBar()
        self.configureTable()
        
        
        do {
            try fetchedResultsController.performFetch()
          } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        
        
    }
    
    func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? ProjectCell else { return }
        let project = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = project.name
        
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "All Projects"
        let addButton = UIBarButtonItem(title: "New Project", style: .plain, target: self, action: #selector(addProjectTapped))
        
        self.navigationItem.rightBarButtonItem = addButton
        //        self.navigationItem.rightBarButtonItem?.title = "Done"
        
        
        
        //        let camera = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: Selector("btnOpenCamera"))
        //        self.navigationItem.rightBarButtonItem = camera
    }
    
    private func fetchProjects() {
        coreDataStack.fetchPersistedData { (results) in
            switch results {
            case .success(let allProjects):
                self.projects = allProjects
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureTable() {
        self.view.addSubview(self.table)
        self.table.frame = self.view.bounds
        self.table.register(ProjectCell.self, forCellReuseIdentifier: "Cell")
        self.table.delegate = self
        self.table.dataSource = self
        self.table.separatorStyle = .none
        
    }
    
    @objc func addProjectTapped(){
//
        let newProjectVC = NewProjectVC()
        newProjectVC.coreDataStack = coreDataStack
        self.present(newProjectVC, animated: true, completion: nil)
//        print("hello")
//        let newProject = Project(context: coreDataStack.managedContext)
//        newProject.name = "Project 3"
//        newProject.color = UIColor.color(red: 13, green: 7, blue: 126, alpha: 0.50)
        
//        do {
//            try         testCDStack?.save()
//
//        } catch{
//            print("error")
//        }
//        self.coreDataStack.saveContext()
//        print("saved")
       
    }
    
}


extension ProjectsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

       return fetchedResultsController.sections?.count ?? 0
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return projects.count
        
        guard let sectionInfo =
            fetchedResultsController.sections?[section] else {
                return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //        let project = projects[indexPath.row]
        //        cell.textLabel?.text = project.name
        //        cell.textLabel?.backgroundColor = project.color as? UIColor
        //        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let destinationVC = TasksVC()
        let project = fetchedResultsController.object(at: indexPath)
        destinationVC.selectedProject = project
//        destinationVC.managedContext = coreDataStack.managedContext
        destinationVC.testCD = coreDataStack
        self.navigationController?.pushViewController(destinationVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          let project = fetchedResultsController.object(at: indexPath)
        //        do {
        self.coreDataStack.managedContext.delete(project)
        self.coreDataStack.saveContext()
    }
    
}

extension ProjectsVC {

  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    table.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {

    switch type {
    case .insert:
      table.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      table.deleteRows(at: [indexPath!], with: .automatic)
    case .update:
      let cell = table.cellForRow(at: indexPath!) as! ProjectCell
      configureCell(cell: cell, for: indexPath!)
    case .move:
      table.deleteRows(at: [indexPath!], with: .automatic)
      table.insertRows(at: [newIndexPath!], with: .automatic)
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    table.endUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange sectionInfo: NSFetchedResultsSectionInfo,
                  atSectionIndex sectionIndex: Int,
                  for type: NSFetchedResultsChangeType) {

    let indexSet = IndexSet(integer: sectionIndex)

    switch type {
    case .insert:
      table.insertSections(indexSet, with: .automatic)
    case .delete:
      table.deleteSections(indexSet, with: .automatic)
    default: break
    }
  }
}
