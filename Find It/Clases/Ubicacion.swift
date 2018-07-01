//
//  Ubicacion.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 01/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Ubicacion: UIViewController,  CLLocationManagerDelegate{
    
    let manager =  CLLocationManager()
    func obtenerUbicacion() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            let location = locations[0]
            print("Latitud: \(location.coordinate.latitude) Longitud: \(location.coordinate.longitude)")
        }
        
    }
    
    
    
    
}
