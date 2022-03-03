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
    
    var reminderClass = ReminderClass()
    var coreDataClass = CoreDataClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successButton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    
    @IBAction func successButtonPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyBoard.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        
        present(mainTabBarController, animated: true, completion: nil)
    }
    
}
