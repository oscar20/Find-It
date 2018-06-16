//
//  ViewController.swift
//  Find It
//
//  Created by d182_oscar_a on 15/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        //Peticion a mi API
        let url = URL(string: "https://api.goodzer.com/products/v0.1/location_details/?locationId=ffy5Pc7R&apiKey=")
        
        //Ejecucion de tarea
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if data != nil {
                print("Datos no vacios")
                let decoder = JSONDecoder()
                let tiendaDatos = try! decoder.decode(Tienda.self, from: data!)
                print(tiendaDatos)
                print(response!)
                
            }else{
                print("Datos nulos")
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

