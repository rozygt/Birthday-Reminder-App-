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
    
    let notificationCenter = UNUserNotificationCenter.current()
    let dateFormatter = DateFormatter()
    var coreDataClass = CoreDataClass()
    
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
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        let request : NSFetchRequest<BirthdayReminderCore> = BirthdayReminderCore.fetchRequest()
        request.sortDescriptors = sortDescriptors

        if coreDataClass.coreDataArray.count == 0{
            mainCollectionView.isHidden = true
            emtyView.isHidden = false
            emtyImage.isHidden = false
            emtyLabel.isHidden = false
        }
        else{
            do{
                coreDataClass.coreDataArray = try coreDataClass.context.fetch(request)
                mainCollectionView.reloadData()
            }catch{
                print("Error")
            }
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
        cell.nameLabel.text = coreDataClass.coreDataArray[indexPath.row].name
        cell.dateLabel.text = dateFormatter.string(from: coreDataClass.coreDataArray[indexPath.row].birtdaydate!)
        
        return cell
        
    }
    
}

