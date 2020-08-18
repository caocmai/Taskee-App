//
//  NotificationUtility.swift
//  Taskee App
//
//  Created by Cao Mai on 8/17/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class NotificationHelper {
    static func addNotification(about title: String, at date: Date, uniqueID id: String, image: UIImage) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            //            print(error as Any)
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Deadline Near!"
        content.body = "\(title) is due in 1 hour."
        
        if let attachment = UNNotificationAttachment.create(identifier: id, image: image, options: nil) {
            content.attachments = [attachment]
        }
        
        let dateNew = date.addingTimeInterval(-3600) // move the date back an hour to notify 1 hour before task due date
        
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
