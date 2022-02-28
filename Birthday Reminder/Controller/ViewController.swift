//
//  ViewController.swift
//  Birthday Reminder
//
//  Created by Rozerin on 22.02.2022.
//

import UIKit
import CoreData
import UserNotifications

protocol DidSelectUserDelegate{
    func didSelect(row: Int)
        
    
}

class ViewController: UIViewController {
   
    @IBOutlet var mainCollectionView: UICollectionView!
    @IBOutlet var emtyLabel: UILabel!
    @IBOutlet var emtyImage: UIImageView!
    @IBOutlet var emtyView: UIView!
    
    let notificationCenter = UNUserNotificationCenter.current()
    let dateFormatter = DateFormatter()
    var coreDataClass = CoreDataClass()
    var reminderClass = ReminderClass()
    var delegate: DidSelectUserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        checkdata()
        
        print(self.coreDataClass.coreDataArray.count)
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
        // Data gemeden coredata array count 0 ise data göstermiyor, yukarıda do catch bloğu ile datayı fetch ettik
        // sonra count 0 ise veya degilse islem gercekleştirdik
        // classa data taşı ben create view controllerda savecontecxt bıraktım onu ordan al olabildiğinde verileri taşı classa
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       
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
        print(dateFormatter.string(from: coreDataClass.coreDataArray[indexPath.row].birthdaydate!))
        let refreshAlert = UIAlertController(title: "Choose", message: "Please the choose item", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Edit Project", style: .default, handler: { [self] (action: UIAlertAction!) in
            
            let navVC = tabBarController?.viewControllers![1] as! UINavigationController
            let cartTableViewController = navVC.topViewController as! CreateViewController
            cartTableViewController.state = .update
            cartTableViewController.indexPath = indexPath.row
            delegate?.didSelect(row: indexPath.row)
            cartTableViewController.reminder = coreDataClass.coreDataArray[indexPath.row]
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

