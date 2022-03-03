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
    var state: ReminderPageState = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successButton.layer.cornerRadius = 10
        createUpdateControls()

        // Do any additional setup after loading the view.
        
    }
    func createUpdateControls(){
        if state == .create {
            successMessageLabel.text = "Birthday date added success."
        }
        else{
            successMessageLabel.text = "Birthday update successfully added"
        }
    }
    
    @IBAction func successButtonPressed(_ sender: Any) {
        
        reminderClass.homePagaRedirect(vc: self)
    }
    
}
