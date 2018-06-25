//
//  Location.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 24/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

struct Location: Decodable{
    let address: String?
    let city: String?
    let id: String?
    let lat: Double?
    let lng: Double?
    let name: String?
    let phone: String?
    let state: String?
    let store_id: String?
    let zipcode: String?
}
