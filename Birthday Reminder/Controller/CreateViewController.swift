//
//  CreateViewController.swift
//  Birthday Reminder
//
//  Created by Rozerin on 22.02.2022.
//

import UIKit
import DatePicker
import CoreData

enum ReminderPageState {
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
    
    var reminderClass = ReminderClass()
    var coreDataClass = CoreDataClass()
    var variableClass = VariableClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButtonn.layer.cornerRadius = 10
        dateTimeLabel.isHidden = true
        userImageView.image = UIImage(named: "user")
        userImageView.contentMode = UIView.ContentMode.scaleAspectFill
        userImageView.layer.cornerRadius = (userImageView.frame.height) / 2
        userImageView.layer.masksToBounds = false
        userImageView.clipsToBounds = true
        nameTextField.delegate = self
        surnameTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
            variableClass.notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted){
                print("Permission Denied")
            }
        }
        self.hideKeyboardWhenTappedAround()
        
        if variableClass.state == .create{
            addButton.title = "Done"
        }
        else{
            getReminder()
            addButton.title = "Update"
        }
    }
    
    func getReminder(){
        nameTextField.text = variableClass.reminder?.value(forKey: "name") as? String
        surnameTextField.text = variableClass.reminder?.value(forKey: "surname") as? String
        let picture = variableClass.reminder?.value(forKey: "image")
        userImageView.image  = UIImage(data: picture as! Data)
        if let strDate = variableClass.reminder?.value(forKey: "birthdaydate") as? Date{
            dateTimeLabel.text = reminderClass.formattedDateGet(date: strDate)
        }
        dateTimeLabel.isHidden = false
    }
    
    func saveReminder(){
        let newAdd = BirthdayReminderCore(context: self.coreDataClass.context)
        newAdd.name = self.nameTextField.text!
        newAdd.surname = self.surnameTextField.text!
        let imageAsNSData = self.userImageView.image!.jpegData(compressionQuality: 1)
        newAdd.image = imageAsNSData
        newAdd.birthdaydate = self.variableClass.dateTransfer
        
        self.coreDataClass.coreDataArray.append(newAdd)
        coreDataClass.saveContext()
        
        coreDataClass.save(titleBox: nameTextField.text!, messageBox: dateTimeLabel.text!)
    }
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1940)!
        let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2023)!
        // Create picker object
        let datePicker = DatePicker()
        datePicker.setup(beginWith: Date(), min: minDate, max: maxDate) { [self] (selected, date) in
            if selected, let selectedDate = date {
                self.dateTimeLabel.text = self.reminderClass.formattedDateGet(date: selectedDate)
                variableClass.dateTransfer = selectedDate
                self.dateTimeLabel.isHidden = false
            }
            else {
                print("cancelled")
            }
        }
        // Display
        datePicker.show(in: self, on: (sender as! UIView))
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        reminderClass.transition(vc: self, identifier: "MainTabBarController")
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if nameTextField.text == "" && surnameTextField.text == "" || nameTextField.text == nil && surnameTextField.text == nil{
            reminderClass.warningAction(errorMessage: "Name and surname cannot be empty.", viewController: self)
        }
        else if dateTimeLabel.isHidden == true{
            reminderClass.warningAction(errorMessage: "Date of birth field cannot be empty.", viewController: self)
        }
        else{
            if variableClass.state == .create {
                let newAdd = BirthdayReminderCore(context: self.coreDataClass.context)
                newAdd.name = self.nameTextField.text!
                newAdd.surname = self.surnameTextField.text!
                let imageAsNSData = self.userImageView.image!.jpegData(compressionQuality: 1)
                newAdd.image = imageAsNSData
                newAdd.birthdaydate = self.variableClass.dateTransfer
                
                self.coreDataClass.coreDataArray.append(newAdd)
                reminderClass.transition(vc: self, identifier: "SuccessViewController")
            }
            else {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BirthdayReminderCore")
                fetchRequest.predicate = NSPredicate(format: "name = %@", variableClass.reminder?.value(forKey: "name") as! CVarArg)
                do {
                    let test = try self.coreDataClass.context.fetch(fetchRequest)
                    if test.count == 1 {
                        let objectUpdate = test[0] as! NSManagedObject
                        objectUpdate.setValue(self.nameTextField.text!, forKey: "name")
                        objectUpdate.setValue(self.surnameTextField.text!, forKey: "surname")
                        objectUpdate.setValue(variableClass.dateTransfer, forKey: "birthdaydate")
                        objectUpdate.setValue(self.userImageView.image!.jpegData(compressionQuality: 1), forKey: "image")
                        self.coreDataClass.saveContext()
                    }
                } catch {
                    print(error)
                }
                reminderClass.transition(vc: self, identifier: "SuccessViewController")
            }
        }
    }
        
    func openGallery() {
        variableClass.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(variableClass.imagePicker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            variableClass.imagePicker.delegate = self
            variableClass.imagePicker.sourceType = .camera
            variableClass.imagePicker.allowsEditing = false
            variableClass.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            present(variableClass.imagePicker, animated: true, completion: nil)
        } else {
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
        variableClass.imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension CreateViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

