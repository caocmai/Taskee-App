//
//  Task+CoreDataProperties.swift
//  Taskee App
//
//  Created by Cao Mai on 7/28/20.
//  Copyright © 2020 Make School. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var status: Bool
    @NSManaged public var taskImage: Data?
    @NSManaged public var title: String?
    @NSManaged public var dateComplete: Date?
    @NSManaged public var parentProject: Project?

}
