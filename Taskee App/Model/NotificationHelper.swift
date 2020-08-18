//
//  NotificationUtility.swift
//  Taskee App
//
//  Created by Cao Mai on 8/17/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class NotificationHelper {
    static func addNotification(project: String, about title: String, at date: Date, alertBeforeSecs sec: Double, uniqueID id: String, image: UIImage) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            //            print(error as Any)
        }
        
        var dueAtString = ""

        switch sec {
        case 36000.0:
            dueAtString = "10 hours"
        case 18000.0:
            dueAtString = "5 hours"
        case 3600.0:
            dueAtString = "1 hour"
        case 1800.0:
            dueAtString = "30 minutes"
        case 300.0:
            dueAtString = "5 minutes"
        case 60.0:
            dueAtString = "1 minute"
        default:
            dueAtString = "1 hour"
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Deadline For \(project) Project Near!"
        content.body = "\(title) is due in \(dueAtString)."
        
        if let attachment = UNNotificationAttachment.create(identifier: id, image: image, options: nil) {
            content.attachments = [attachment]
        }
        
        let dateNew = date.addingTimeInterval(sec * -1) // move the date back before task due date based on user choice
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateNew)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print(error as Any, "error!!!")
                
            }
        }
    }
    
    static func removeTaskFromNotification(id: UUID) {
        let stringID = id.uuidString
        let center = UNUserNotificationCenter.current()
                        // center.removeDeliveredNotifications(withIdentifiers: [String])
        center.removePendingNotificationRequests(withIdentifiers: [stringID])
    }
}
