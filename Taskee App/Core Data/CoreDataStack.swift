//
//  CoreDataStack.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String = "Project"
    
    //    init(modelName: String) {
    //      self.modelName = modelName
    //    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    lazy var managedContext: NSManagedObjectContext = {
        // get location of stored core data file
        //        print(self.storeContainer.persistentStoreDescriptions.first?.url)
        return self.storeContainer.viewContext
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    // currently not using to fetch projects
    func fetchAllProjects(completion: @escaping(Result<[Project]>) -> Void) {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        do {
            let allProjects = try managedContext.fetch(fetchRequest)
            completion(.success(allProjects))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil, selectedProject: Project, completion: @escaping(Result<[Task]>) -> Void) {
        
        let categoryPredicate = NSPredicate(format: "parentProject == %@", selectedProject)
            let sectionSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        //
            request.sortDescriptors = [sectionSortDescriptor]
        
        //        if let addtionalPredicate = predicate {
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
        //        } else {
        //            request.predicate = categoryPredicate
        //        }
        
        do {
            let tasks = try managedContext.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}
