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
    //@IBOutlet weak var imagenUbicacion: UIImageView!
    @IBOutlet weak var webSite: UILabel!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                self.contentView.layer.borderWidth = 1.0
                self.contentView.layer.borderColor = UIColor.gray.cgColor
            }else{
                self.contentView.layer.borderColor = UIColor.clear.cgColor
                self.contentView.backgroundColor = UIColor.clear
            }
        }
    }

}
