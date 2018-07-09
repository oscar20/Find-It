//
//  Product.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 24/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import Foundation

struct Product: Decodable{
    let id: CLongLong?
    let image: String?
    let original_price: Double?
    let price: Double?
    let title: String?
    let url : String?
}
