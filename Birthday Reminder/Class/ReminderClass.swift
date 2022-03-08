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
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
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
    
    func transition(vc: UIViewController, identifier: String, strText: String){
        let mainTabBarController = self.storyBoard.instantiateViewController(identifier: identifier) as? SuccessViewController
        mainTabBarController!.str = strText
        mainTabBarController!.modalPresentationStyle = .fullScreen
        
        vc.present(mainTabBarController!, animated: true, completion: nil)
    }
    
    func backTransition(vc: UIViewController, identifier: String){
        let mainTabBarController = self.storyBoard.instantiateViewController(identifier: identifier)
        mainTabBarController.modalPresentationStyle = .fullScreen
        
        vc.present(mainTabBarController, animated: true, completion: nil)
    }

}
