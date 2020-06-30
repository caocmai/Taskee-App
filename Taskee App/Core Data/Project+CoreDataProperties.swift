//
//  Project+CoreDataProperties.swift
//  Taskee App
//
//  Created by Cao Mai on 6/30/20.
//  Copyright © 2020 Make School. All rights reserved.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var projectTasks: NSSet?

}

// MARK: Generated accessors for projectTasks
extension Project {

    @objc(addProjectTasksObject:)
    @NSManaged public func addToProjectTasks(_ value: Task)

    @objc(removeProjectTasksObject:)
    @NSManaged public func removeFromProjectTasks(_ value: Task)

    @objc(addProjectTasks:)
    @NSManaged public func addToProjectTasks(_ values: NSSet)

    @objc(removeProjectTasks:)
    @NSManaged public func removeFromProjectTasks(_ values: NSSet)

}
