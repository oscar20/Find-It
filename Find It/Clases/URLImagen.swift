//
//  Ubicacion.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 01/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class URLImagen: UIViewController{
    
    func obtenerImagenConURL(objetoStore : Product, completionHandler: @escaping (UIImage?, Error?) -> () ){
        if let urlImagen = objetoStore.image{
            //print("NO NIL")
            //print(urlImagen)
            let urlImagenPeticion = URL(string: urlImagen)
            Alamofire.request(urlImagenPeticion!).responseData { (responseData) in
                if let error = responseData.error{
                    print("No se pudo cargar la imagen \(error)")
                }
                guard let data = responseData.data else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async(execute: {
                    completionHandler(image,nil)
                })
            }
        }else{
            print("nil")
            let imagenVacia = UIImage(named: "noDisponible")
            completionHandler(imagenVacia,nil)
        }
        
    }
    
    
    
}
