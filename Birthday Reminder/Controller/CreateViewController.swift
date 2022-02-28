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
protocol PageStateDelegate{
    func didSelectState(value:String)
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
    var state: ReminderPageState = .create
    var reminder: NSManagedObject?
    var newState = ""
    var delegate : PageStateDelegate?
    var reminderClass = ReminderClass()
    var coreDataClass = CoreDataClass()
    var dateTransfer = Date()
    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButtonn.layer.cornerRadius = 10
        dateTimeLabel.isHidden = false
        userImageView.image = UIImage(named: "user")
        nameTextField.delegate = self
        surnameTextField.delegate = self
        delegate = self
        self.hideKeyboardWhenTappedAround()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted){
                print("Permission Denied")
            }
        }

        self.hideKeyboardWhenTappedAround()
        
        if state == .create{

            print("buraya girdi11")
            
           
        }
        else{
            print("buraya girdi")
            //getReminder()

        }
    }
    
    func getReminder(){
        print(reminder?.value(forKey: "name") as? String as Any)
        nameTextField.text = reminder?.value(forKey: "name") as? String
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
    
    @IBAction func canclButtonPressed(_ sender: Any) {
        let mainTabBarController = self.storyboard!.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if nameTextField.text == "" && dateTimeLabel.isHidden == true{
            let alert = UIAlertController(title: "Warning", message: "Name and date of birth cannot be empty.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if dateTimeLabel.isHidden == true{
            let alert = UIAlertController(title: "Warning", message: "Date of birth field cannot be empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if nameTextField.text == ""{
            let alert = UIAlertController(title: "Warning", message: "Name field cannot be empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            let newAdd = BirthdayReminderCore(context: self.coreDataClass.context)
            newAdd.name = self.nameTextField.text! + self.surnameTextField.text!
            
            let imageAsNSData = self.userImageView.image!.jpegData(compressionQuality: 1)
            newAdd.image = imageAsNSData
            newAdd.birthdaydate = self.dateTransfer
            
            self.coreDataClass.coreDataArray.append(newAdd)
            coreDataClass.saveContext()
            print(self.coreDataClass.coreDataArray.count)
            let alert = UIAlertController(title: "Succes", message: "birthday date added succes", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                let mainTabBarController = self.storyboard!.instantiateViewController(identifier: "MainTabBarController")
                mainTabBarController.modalPresentationStyle = .fullScreen
                
                self.present(mainTabBarController, animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
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



extension CreateViewController: PageStateDelegate{
    func didSelectState(value: String) {
        dateTimeLabel.text = value
    }
}
