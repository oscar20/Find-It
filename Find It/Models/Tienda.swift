//
//  tienda.swift
//  Find It
//
//  Created by d182_oscar_a on 15/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import Foundation

struct Tienda: Decodable {
    let location: Location
    let status: String
}

struct Location: Decodable{
     let address: String
     let city: String
     let id: String
     let lat: Double
     let lng: Double
     let name: String
     let phone: String
     let state: String
     let store_id: String
     let zipcode: String
}
