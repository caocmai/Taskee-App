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
    let searchController = UISearchController(searchResultsController: nil)
  
    var table: UITableView = {
        let newTable = UITableView()
        return newTable
    }()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(Project.name), ascending: true)
        // Will crash when save object if activated; seems like can't sort by color
        let colorSort = NSSortDescriptor(key: #keyPath(Project.color), ascending: true)
        
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged
        )
        self.table.refreshControl = refreshControl
        
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Seach."
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchProjects()
    }
    
    @objc func refresh() {
        self.fetchProjects()
        self.table.refreshControl?.endRefreshing()
        
    }
    
    
    func fetchProjects() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        self.table.reloadData()
    }
    
    func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? ProjectCell else { return }
        let project = fetchedResultsController.object(at: indexPath)
        cell.configureUIForProject(with: project)
        //        cell.textLabel?.numberOfLines = 0
        
        //        let interaction = UIContextMenuInteraction(delegate: self)
        //        cell.addInteraction(interaction)
        
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "All Projects"
        let addButton = UIBarButtonItem(title: "New Project", style: .plain, target: self, action: #selector(addProjectTapped))
        self.navigationItem.rightBarButtonItem = addButton

    }
    
    //    private func fetchProjects() {
    //        coreDataStack.fetchPersistedData { (results) in
    //            switch results {
    //            case .success(let allProjects):
    //                self.projects = allProjects
    //            case .failure(let error):
    //                print(error)
    //            }
    //        }
    //    }
    
    private func configureTable() {
        self.view.addSubview(self.table)
        self.table.frame = self.view.bounds
        self.table.register(ProjectCell.self, forCellReuseIdentifier: ProjectCell.identifier)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.separatorStyle = .none
        
        
    }
    
    @objc func addProjectTapped(){
        //
        let newProjectVC = NewProjectVC()
        newProjectVC.coreDataStack = coreDataStack
        let navController = UINavigationController(rootViewController: newProjectVC)
        self.present(navController, animated: true, completion: nil)

        
    }
    
}

// - MARK: UITableView
extension ProjectsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //
    //        return fetchedResultsController.sections?.count ?? 0
    //    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return projects.count
        
        guard let sectionInfo =
            fetchedResultsController.sections?[section] else {
                return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCell.identifier, for: indexPath)
        cell.imageView?.isHidden = true
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = TasksVC()
        let project = fetchedResultsController.object(at: indexPath)
        destinationVC.selectedProject = project
        //        destinationVC.managedContext = coreDataStack.managedContext
        destinationVC.coreDataStack = coreDataStack
        self.table.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let project = fetchedResultsController.object(at: indexPath)
        self.coreDataStack.managedContext.delete(project)
        self.coreDataStack.saveContext()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

// - MARK: NSFetchResultsController

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
            print("update")
            //            table.reloadRows(at: [indexPath!], with: .automatic)
            let cell = table.cellForRow(at: indexPath!) as! ProjectCell
            configureCell(cell: cell, for: indexPath!)
        case .move:
            table.deleteRows(at: [indexPath!], with: .automatic)
            table.insertRows(at: [newIndexPath!], with: .automatic)
        default:
            fatalError("not valid action")
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
    //                    didChange sectionInfo: NSFetchedResultsSectionInfo,
    //                    atSectionIndex sectionIndex: Int,
    //                    for type: NSFetchedResultsChangeType) {
    //
    //        let indexSet = IndexSet(integer: sectionIndex)
    //
    //        switch type {
    //        case .insert:
    //            table.insertSections(indexSet, with: .automatic)
    //        case .delete:
    //            table.deleteSections(indexSet, with: .automatic)
    //        default: break
    //        }
    //    }
    
}

// - MARK: Context Menu

extension ProjectsVC: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint)
        -> UIContextMenuConfiguration? {
            return nil
    }
    
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let favorite = UIAction(title: "Edit...") { _ in
            //            print(indexPath.row)
            let editVC = NewProjectVC()
            let project = self.fetchedResultsController.object(at: indexPath)
            editVC.selectedProject = project
            //        destinationVC.managedContext = coreDataStack.managedContext
            editVC.coreDataStack = self.coreDataStack
            self.table.deselectRow(at: indexPath, animated: true)
            
            let navController = UINavigationController(rootViewController: editVC)
            self.present(navController, animated: true, completion: nil)
            
            
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: .none, discoverabilityTitle: .none, attributes: .destructive, state: .off) { (_) in
            let project = self.fetchedResultsController.object(at: indexPath)
            self.coreDataStack.managedContext.delete(project)
            self.coreDataStack.saveContext()
        }
        
    
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "Actions", children: [favorite, delete])
        }
    }
}

// - MARK: Search

extension ProjectsVC: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        if (text?.isEmpty)! {
            // This is needed to return to displying all projects
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(value: true)
        } else {
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "( name contains[cd] %@ )", text!)
            do {
                try self.fetchedResultsController.performFetch()
                self.table.reloadData()
            } catch {}
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
    }
    
    
}