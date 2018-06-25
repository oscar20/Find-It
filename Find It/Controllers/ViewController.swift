//
//  ViewController.swift
//  Find It
//
//  Created by d182_oscar_a on 15/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let registerButton: UIButton = {
        
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 232/255, green: 173/255, blue: 72/255, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Recupera datos", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        //btn.addTarget(self, action: #selector(recuperaDatos), for: .touchUpInside)
        btn.addTarget(self, action: #selector(getStores), for: .touchUpInside)
         return btn
        
    }()
    
    let parametro: UITextField = {
        let p = UITextField()
        p.text = "v-neck+sweater"
        p.backgroundColor = UIColor.yellow
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(registerButton)
        view.addSubview(parametro)
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        parametro.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30).isActive = true
        parametro.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func recuperaDatos(){
        print("Func recuperaDatos")
        let apiKey = ""
        let urlString = "https://api.goodzer.com/products/v0.1/location_details/?locationId=\(String(describing: parametro.text!))&apiKey=\(apiKey)"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            print("Fetching data...")
            guard let data = data else {return}
            
        //Parseo de Json
            do {
                let store = try JSONDecoder().decode(Store.self, from: data)
                print("Status de peticion...\(String(describing: store.status))")
                print("Address: \(String(describing: store.location?.address))")
                print("City: \(String(describing: store.location?.city))")
                print("Latitud: \(String(describing: store.location?.lat))")
                print("Longitud: \(String(describing: store.location?.lng))")
            }catch let error{
                print("Error:", error)
            }
                
            
        }.resume()
        
    }
    
    @objc func getStores(){
        let latitud = "40.714353"
        let longitud = "-74.005973"
        print("Entrando a metodo pararecuperar tiendas cercanas")
        let apiKey = ""
        let urlString = "https://api.goodzer.com/products/v0.1/search_stores/?query=\(parametro.text!)&lat=\(latitud)&lng=\(longitud)&radius=5&priceRange=30:120&apiKey=\(apiKey)"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            print("Obteniendo tiendas con cierto producto")
            guard let data = data else {return}
            
            //Parseo...
            do{
                let productStore = try JSONDecoder().decode(PeticionProducto.self, from: data)
                print("Status: \(String(describing: productStore.status))")
                print("WebSite de primer tienda: \(String(describing: productStore.stores?.first?.website))")
                print("Stores_found: \(String(describing: productStore.stores_found))")
                print("Time: \(String(describing: productStore.time))")
            }catch let error{
                print("Error: ", error)
            }
            
        }.resume()
    }



}

