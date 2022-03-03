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

class CoreDataClass{

    var coreDataArray = [BirthdayReminderCore]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentDateTime = Date()
    
    func saveContext(){
        
        do{
            try context.save()
            print("SAVE BASARILI")
            
        }catch{
            print("Save Error")
        }
        
    }
    
//    func updateContext(firstName : String, surName: String, birthdayDate: Date, personImage: UIImage, selectProjectRow: Int){
//        let data = coreDataArray[selectProjectRow]
//        let imageAsNSData = personImage.jpegData(compressionQuality: 1)
//        data.setValue(firstName , forKey: "name")
//        data.setValue(surName, forKey: "surname")
//        data.setValue(currentDateTime, forKey: "birtdaydate")
//        data.setValue(imageAsNSData, forKey: "image")
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
        
//    }
}
    
    
