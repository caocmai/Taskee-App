//
//  CoreDataStack.swift
//  PLUTrainer
//
//  Created by Cao Mai on 6/27/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import Foundation
import CoreData

//class CoreDataStack {
//
//    private lazy var storeContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Produce")
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                print("Error: \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
//    lazy var managedContext: NSManagedObjectContext = {
//        // get location of stored core data file
//        print(self.storeContainer.persistentStoreDescriptions.first?.url)
//        return self.storeContainer.viewContext
//    }()
//
//    func saveContext() {
//        guard managedContext.hasChanges else { return }
//
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Error: \(error), \(error.userInfo)")
//        }
//    }
//
//    func fetchPersistedData(completion: @escaping(Result<[Produce]>) -> Void) {
//        let fetchRequest: NSFetchRequest<Produce> = Produce.fetchRequest()
//        do {
//            let allProduces = try managedContext.fetch(fetchRequest)
//            completion(.success(allProduces))
//        } catch {
//            completion(.failure(error))
//        }
//    }
//}
//
//enum Result<T> {
//    case success(T)
//    case failure(Error)
//}
