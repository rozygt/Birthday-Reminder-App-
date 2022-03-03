//
//  MainCollectionViewCell.swift
//  Birthday Reminder
//
//  Created by Rozerin on 23.02.2022.
//

import UIKit
import SwiftUI

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var imagaView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgImageView.layer.cornerRadius = 20
        bgImageView.layer.borderColor = UIColor.brown.cgColor
        imagaView.contentMode = UIView.ContentMode.scaleAspectFill
        imagaView.layer.cornerRadius = self.frame.height / 3
        imagaView.layer.masksToBounds = false
        imagaView.clipsToBounds = true
    
        
    }
    
}
