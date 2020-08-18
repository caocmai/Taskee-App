//
//  Task+CoreDataProperties.swift
//  Taskee App
//
//  Created by Cao Mai on 8/17/20.
//  Copyright © 2020 Make School. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dateCompleted: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var taskID: UUID?
    @NSManaged public var taskImage: Data?
    @NSManaged public var title: String?
    @NSManaged public var parentProject: Project?

}
