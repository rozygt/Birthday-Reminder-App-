//
//  reminderClass.swift
//  Birthday Reminder
//
//  Created by Rozerin on 25.02.2022.
//

import Foundation
import CoreData

class ReminderClass{
    func formattedDateGet(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
