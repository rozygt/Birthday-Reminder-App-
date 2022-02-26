//
//  CreateViewController.swift
//  Birthday Reminder
//
//  Created by Rozerin on 22.02.2022.
//

import UIKit
import DatePicker
import CoreData

enum ReminderAddPageState {
    case create
    case update
}

class CreateViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var changeImageButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var selectButtonn: UIButton!
    
    let notificationCenter = UNUserNotificationCenter.current()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var array = CoreDataClass()
    var reminderClass = ReminderClass()
    var coreDataClass = CoreDataClass()
    var dateTransfer = Date()
    var selectedImage: UIImage?
    var coreDataArray = [Reminder]()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButtonn.layer.cornerRadius = 10
        dateTimeLabel.isHidden = true
        userImageView.image = UIImage(named: "user")
        nameTextField.delegate = self
        surnameTextField.delegate = self
        //denemee
    }
    
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1990)!
        let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2030)!
        let today = Date()
        // Create picker object
        let datePicker = DatePicker()
        datePicker.setup(beginWith: Date(), min: minDate, max: maxDate) { [self] (selected, date) in
            if selected, let selectedDate = date {
                self.dateTimeLabel.text = self.reminderClass.formattedDateGet(date: selectedDate)
                let selectedDate = dateTransfer
                
                print("\(selectedDate)")
                self.dateTimeLabel.isHidden = false
            } else {
                print("cancelled")
            }
        }
        
        // Display
        datePicker.show(in: self, on: sender as! UIView)
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.coreDataClass.saveReminder(firstName: self.nameTextField.text!, surName: self.surnameTextField.text!, birthdayDate: self.dateTransfer, personImage: self.userImageView.image!)
        coreDataClass.saveContext()
        
//        switch state {
//
//        case .create:
//            self.coreDataClass.saveReminder(firstName: self.nameTextField.text!, surName: self.surnameTextField.text!, birthdayDate: self.dateTransfer, personImage: self.userImageView.image!)
//        case .update:
//            print("UPDATE")
//            coreDataClass.updateContext(firstName: self.nameTextField.text!, surName: self.surnameTextField.text!, birthdayDate: self.dateTransfer, personImage: self.userImageView.image!, selectProjectRow: coreDataArray[Reminder])
//        }
    }
    
    func openGallery() {
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            print("Error Camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        userImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

