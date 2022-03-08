//
//  SuccessViewController.swift
//  Birthday Reminder
//
//  Created by Rozerin on 3.03.2022.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet var succesLabel: UILabel!
    @IBOutlet var successMessageLabel: UILabel!
    @IBOutlet var successButton: UIButton!
    @IBOutlet var successImageView: UIImageView!
    
    var str: String?
    var reminderClass = ReminderClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successButton.layer.cornerRadius = 10
        successMessageLabel.text = str
        
    }
    
    @IBAction func successButtonPressed(_ sender: Any) {
        reminderClass.backTransition(vc: self, identifier: "MainTabBarController")
    }
}
