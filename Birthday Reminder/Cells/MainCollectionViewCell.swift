//
//  MainCollectionViewCell.swift
//  Birthday Reminder
//
//  Created by Rozerin on 23.02.2022.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imagaView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imagaView.contentMode = UIView.ContentMode.scaleAspectFill
        imagaView.layer.cornerRadius = self.frame.height / 3
        imagaView.layer.masksToBounds = false
        imagaView.clipsToBounds = true
    
        
    }
    
}
