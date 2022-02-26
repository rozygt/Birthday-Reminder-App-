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

    var coreDataArray = [Reminder]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentDateTime = Date()
    
    func saveContext(){
        
        do{
            try self.context.save()
            
        }catch{
            print("Save Error")
        }
        
    }
    
    func saveReminder(firstName : String, surName: String, birthdayDate: Date, personImage: UIImage){
        
        let newAdd = Reminder(context: self.context)
        newAdd.name = firstName + surName
        let imageAsNSData = personImage.jpegData(compressionQuality: 1)
        newAdd.image = imageAsNSData
        newAdd.birtdaydate = birthdayDate
        
        coreDataArray.append(newAdd)
        saveContext()
        print(coreDataArray.count)
        
    }
    
    func updateContext(firstName : String, surName: String, birthdayDate: Date, personImage: UIImage, selectProjectRow: Int){
        let data = coreDataArray[selectProjectRow]
        let imageAsNSData = personImage.jpegData(compressionQuality: 1)
        data.setValue(firstName + surName, forKey: "name")
        data.setValue(currentDateTime, forKey: "birtdaydate")
        data.setValue(imageAsNSData, forKey: "image")
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
}
    
    
