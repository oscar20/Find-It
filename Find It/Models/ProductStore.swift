//
//  ProductStore.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 24/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import Foundation

struct ProductStore: Decodable{
    
    let id: String?
    let locations: [Location]?
    let locations_found: Int?
    let name: String?
    let products: [Product]?
    let products_found: Int?
    let realtime_availability: Bool?
    let website: String?
    
    
}
