//
//  CollectionViewCell.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 10/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagenProducto: UIImageView!
    @IBOutlet weak var webSite: UILabel!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                self.contentView.backgroundColor = UIColor(red: 39/255, green: 96/255, blue: 128/255, alpha: 0.1)
                self.contentView.layer.cornerRadius = 5.0
            }else{
                self.contentView.backgroundColor = UIColor.clear
            }
        }
    }

}
