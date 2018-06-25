//
//  Stores.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 24/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import Foundation

struct PeticionProducto: Decodable{
    
    let status: String?
    let stores: [ProductStore]?
    let stores_found: Int?
    let time: Double?
    
}
