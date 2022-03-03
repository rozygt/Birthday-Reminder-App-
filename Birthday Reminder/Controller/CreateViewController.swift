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
    
 
    let notificationCenter = UNUserNotificationCenter.current()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var state: ReminderPageState = .create
    var reminder: NSManagedObject?
    var reminderClass = ReminderClass()
    var coreDataClass = CoreDataClass()
    var dateTransfer = Date()
    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController()
    var delegate: DidSelectUserDelegate?
    var indexPath: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButtonn.layer.cornerRadius = 10
        dateTimeLabel.isHidden = true
        changeImageButton.layer.borderColor = UIColor.systemOrange.cgColor
        changeImageButton.layer.cornerRadius = 1
        userImageView.image = UIImage(named: "user")
        userImageView.contentMode = UIView.ContentMode.scaleAspectFill
        userImageView.layer.cornerRadius = (userImageView.frame.height) / 2
        userImageView.layer.masksToBounds = false
        userImageView.clipsToBounds = true
        nameTextField.delegate = self
        surnameTextField.delegate = self
        delegate = self
        print("Warning \(indexPath)")
        self.hideKeyboardWhenTappedAround()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted){
                print("Permission Denied")
            }
        }
        self.hideKeyboardWhenTappedAround()
        
        if state == .create{
            print("create buraya girdi11")
        }
        else{
            print("update buraya girdi")
            getReminder()
        }
    }
    
    func getReminder(){
        nameTextField.text = reminder?.value(forKey: "name") as? String
        surnameTextField.text = reminder?.value(forKey: "surname") as? String
        let picture = reminder?.value(forKey: "image")
        userImageView.image  = UIImage(data: picture as! Data)
        if let strDate = reminder?.value(forKey: "birthdaydate") as? Date{
            dateTimeLabel.text = reminderClass.formattedDateGet(date: strDate)
            
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            //
            //            if let date = dateFormatter.string(from: strDate) {
            //                print("str \(strDate) \(date)")
            //                dateTimeLabel.text = date
            //            }
        }
        dateTimeLabel.isHidden = false
    }
    
    func saveReminder(){
        let newAdd = BirthdayReminderCore(context: self.coreDataClass.context)
        newAdd.name = self.nameTextField.text!
        newAdd.surname = self.surnameTextField.text!
        let imageAsNSData = self.userImageView.image!.jpegData(compressionQuality: 1)
        newAdd.image = imageAsNSData
        newAdd.birthdaydate = self.dateTransfer
        
        self.coreDataClass.coreDataArray.append(newAdd)
        coreDataClass.saveContext()
        
        notificationCenter.getNotificationSettings { (settings) in
            
            DispatchQueue.main.async
            {
                let title = self.nameTextField.text
                let message = self.dateTimeLabel.text
                
                if(settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title!
                    content.body = message!
                    content.sound = .default
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: self.dateTransfer)
                    //2022-11-17 11:41:00 +0000
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                }
            }
        }
    }

    @IBAction func selectButtonPressed(_ sender: Any) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1940)!
        let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2023)!
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
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let mainTabBarController = self.storyboard!.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if state == .create {
            if nameTextField.text == "" && dateTimeLabel.isHidden == true{
                reminderClass.warningAction(errorMessage: "Name and date of birth cannot be empty.", viewController: self)
            }
            else if dateTimeLabel.isHidden == true{
                reminderClass.warningAction(errorMessage: "Date of birth field cannot be empty.", viewController: self)
            }
            else if nameTextField.text == ""{
                reminderClass.warningAction(errorMessage: "Name field cannot be empty.", viewController: self)
            }
            else{
                print("donebutton girdi /(indexPath)")
                let newAdd = BirthdayReminderCore(context: self.coreDataClass.context)
                newAdd.name = self.nameTextField.text!
                newAdd.surname = self.surnameTextField.text!
                let imageAsNSData = self.userImageView.image!.jpegData(compressionQuality: 1)
                newAdd.image = imageAsNSData
                newAdd.birthdaydate = self.dateTransfer
                
                self.coreDataClass.coreDataArray.append(newAdd)
                coreDataClass.saveContext()
                
                reminderClass.successAction(vc: self)
            }
            
        }
        else {
            if nameTextField.text == "" && dateTimeLabel.isHidden == true{
                reminderClass.warningAction(errorMessage: "Name and date of birth cannot be empty.", viewController: self)
            }
            else if dateTimeLabel.isHidden == true{
                reminderClass.warningAction(errorMessage: "Date of birth field cannot be empty.", viewController: self)
            }
            else if nameTextField.text == ""{
                reminderClass.warningAction(errorMessage: "Name field cannot be empty.", viewController: self)
            }
            else{
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BirthdayReminderCore")
                fetchRequest.predicate = NSPredicate(format: "name = %@", reminder?.value(forKey: "name") as! CVarArg)
                do {
                    let test = try self.coreDataClass.context.fetch(fetchRequest)
                    if test.count == 1 {
                        let objectUpdate = test[0] as! NSManagedObject
                        objectUpdate.setValue(self.nameTextField.text!, forKey: "name")
                        objectUpdate.setValue(self.surnameTextField.text!, forKey: "surname")
                        objectUpdate.setValue(dateTransfer, forKey: "birthdaydate")
                        objectUpdate.setValue(self.userImageView.image!.jpegData(compressionQuality: 1), forKey: "image")
                        coreDataClass.updateContext(firstName: self.nameTextField.text!, surName: self.surnameTextField.text!, birthdayDate: self.dateTransfer, personImage: self.userImageView.image!, selectProjectRow: indexPath)
                        self.coreDataClass.saveContext()
                    }
                } catch {
                    print(error)
                }
                
//                coreDataClass.updateContext(firstName: self.nameTextField.text!, surName: self.surnameTextField.text!, birthdayDate: self.dateTransfer, personImage: self.userImageView.image!, selectProjectRow: indexPath)
                
                reminderClass.successAction(vc: self)
            }
        }
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
extension CreateViewController: DidSelectUserDelegate{
    func didSelect(row: Int) {
        let rowNumber: Int = row
        indexPath = row
    }
}

