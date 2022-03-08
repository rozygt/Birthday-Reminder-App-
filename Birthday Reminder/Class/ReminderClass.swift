//
//  reminderClass.swift
//  Birthday Reminder
//
//  Created by Rozerin on 25.02.2022.

import Foundation
import CoreData
import UIKit
import SwiftUI

class ReminderClass{
    func formattedDateGet(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func warningAction(errorMessage : String, viewController: UIViewController){
        let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func successAction(vc: UIViewController){
            let alert = UIAlertController(title: "Success", message: "Birthday date added success", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyBoard.instantiateViewController(identifier: "MainTabBarController")
                mainTabBarController.modalPresentationStyle = .popover
                
                vc.present(mainTabBarController, animated: true, completion: nil)
                
            }))
            vc.present(alert, animated: true, completion: nil)
        }
    
    func updateAction(vc: UIViewController){
        let alert = UIAlertController(title: "Update success", message: "Birthday update successfully added", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyBoard.instantiateViewController(identifier: "MainTabBarController")
            mainTabBarController.modalPresentationStyle = .fullScreen
            
            vc.present(mainTabBarController, animated: true, completion: nil)
            
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}
