//
//  CoreDataClass.swift
//  Birthday Reminder
//
//  Created by Rozerin on 25.02.2022.
//

import Foundation
import SwiftyJSON
import CoreData
import UIKit
import SwiftUI

class CoreDataClass{

    var coreDataArray = [BirthdayReminderCore]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentDateTime = Date()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func saveContext(){
        
        do{
            try context.save()
            
        }catch{
            print("Save Error")
        }
    }
    
    func save(titleBox: String, messageBox: String){
        notificationCenter.getNotificationSettings { (settings) in
        DispatchQueue.main.async
        {
            let title = titleBox
            let message = messageBox
            
            if(settings.authorizationStatus == .authorized)
            {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                content.sound = .default
                
                var dateTransfer = Date()
                let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: dateTransfer)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                self.notificationCenter.add(request) { (error) in
                    if(error != nil)
                    {
                        print("Error " + error.debugDescription)
                        return
                    }
                }
            }
        }
    }
    }
}
    
    
