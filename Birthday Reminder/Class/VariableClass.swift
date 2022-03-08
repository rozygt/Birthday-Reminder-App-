//
//  VariableClass.swift
//  Birthday Reminder
//
//  Created by Rozerin on 8.03.2022.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class VariableClass{
    
    let notificationCenter = UNUserNotificationCenter.current()
    let dateFormatter = DateFormatter()
    var state: ReminderPageState = .create
    var reminder: NSManagedObject?
    var dateTransfer = Date()
    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController()
    var indexPath: Int = 0
}
