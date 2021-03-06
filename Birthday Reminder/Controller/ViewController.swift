//
//  ViewController.swift
//  Birthday Reminder
//
//  Created by Rozerin on 22.02.2022.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController {
   
    @IBOutlet var mainCollectionView: UICollectionView!
    @IBOutlet var emtyLabel: UILabel!
    @IBOutlet var emtyImage: UIImageView!
    @IBOutlet var emtyView: UIView!

    var coreDataClass = CoreDataClass()
    var reminderClass = ReminderClass()
    var variableClass = VariableClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        checkdata()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkdata()
    }
    
    func checkdata() {
        let sectionSortDescriptor = NSSortDescriptor(key: "birthdaydate", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        let request : NSFetchRequest<BirthdayReminderCore> = BirthdayReminderCore.fetchRequest()
        request.sortDescriptors = sortDescriptors
        do{
            coreDataClass.coreDataArray = try coreDataClass.context.fetch(request)
            mainCollectionView.reloadData()
        }catch{
            print("Error")
        }

        if coreDataClass.coreDataArray.count == 0{
            mainCollectionView.isHidden = true
            emtyView.isHidden = false
            emtyImage.isHidden = false
            emtyLabel.isHidden = false
        }
        else{
            mainCollectionView.isHidden = false
            emtyView.isHidden = true
            emtyImage.isHidden = true
            emtyLabel.isHidden = true
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coreDataClass.coreDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {fatalError()}
        
        cell.imagaView.image = UIImage(data: coreDataClass.coreDataArray[indexPath.row].image!)
        cell.nameLabel.text = coreDataClass.coreDataArray[indexPath.row].name! + " " + coreDataClass.coreDataArray[indexPath.row].surname!
        cell.dateLabel.text = reminderClass.formattedDateGet(date: coreDataClass.coreDataArray[indexPath.row].birthdaydate!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(variableClass.dateFormatter.string(from: coreDataClass.coreDataArray[indexPath.row].birthdaydate!))
        let refreshAlert = UIAlertController(title: "Choose", message: "Please the choose item", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Edit Project", style: .default, handler: { [self] (action: UIAlertAction!) in
            
            let navVC = tabBarController?.viewControllers![1] as! UINavigationController
            let cartTableViewController = navVC.topViewController as! CreateViewController
            cartTableViewController.variableClass.state = .update
            cartTableViewController.variableClass.indexPath = indexPath.row
            cartTableViewController.variableClass.reminder = coreDataClass.coreDataArray[indexPath.row]
            tabBarController?.selectedIndex = 1
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "Delete Project", style: .cancel, handler: { (action: UIAlertAction!) in
            let fetchRequest = NSFetchRequest<BirthdayReminderCore>(entityName: "BirthdayReminderCore")
            fetchRequest.predicate = NSPredicate(format: "birthdaydate = %@", self.coreDataClass.coreDataArray[indexPath.row].birthdaydate! as CVarArg)
            do {
                let objects = try self.coreDataClass.context.fetch(fetchRequest)
                for object in objects {
                    self.coreDataClass.context.delete(object)
                    self.coreDataClass.coreDataArray.remove(at: indexPath.row)
                }
                try self.coreDataClass.context.save()
            } catch _ {
            }
            self.mainCollectionView.reloadData()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
}

