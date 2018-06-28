//
//  ViewController.swift
//  Find It
//
//  Created by d182_oscar_a on 15/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let productLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "¿Què producto estás buscando?"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let registerButton: UIButton = {
        
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 232/255, green: 173/255, blue: 72/255, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Buscar", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
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
        view.addSubview(productLabel)
        
        productLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        parametro.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 30).isActive = true
        parametro.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: parametro.bottomAnchor, constant: 30).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    @objc func recuperaDatos(){
        print("Func recuperaDatos")
        let apiKey = "4ee7cdf8c6a05e6f91f8077f3bd003ba"
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
        //antes de armar cualquier peticion debo validar si lo que ingreso en el text field es valido
        
        guard let miParametro = parametro.text else {return}
        let trimmed  = miParametro.trimmingCharacters(in: .whitespaces)
        print(trimmed)
        let formatoCadena = trimmed.replacingOccurrences(of: " ", with: "+")
        if formatoCadena.isEmpty{
            print("Cadena vacia...")
        }else{
            print("..\(formatoCadena)..")
            let latitud = "40.714353"
            let longitud = "-74.005973"
            print("Entrando a metodo pararecuperar tiendas cercanas")
            let apiKey = ""
            let urlString = "https://api.goodzer.com/products/v0.1/search_stores/?query=\(formatoCadena)&lat=\(latitud)&lng=\(longitud)&radius=5&priceRange=30:120&apiKey=\(apiKey)"
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                print("Obteniendo tiendas con cierto producto")
                guard let data = data else {return}
                
                //Parseo...
                do{
                    let productStore = try JSONDecoder().decode(PeticionProducto.self, from: data)
                    if productStore.stores_found == nil || productStore.stores_found! == 0 {
                        print("No se encontro ninguna tienda con el producto")
                    }else{
                        print("Status: \(String(describing: productStore.status))")
                        print("WebSite de primer tienda: \(String(describing: productStore.stores?.first?.website))")
                        print("Stores_found: \(String(describing: productStore.stores_found))")
                        print("Time: \(String(describing: productStore.time))")
                    }
                }catch let error{
                    print("Error: ", error)
                }
            }.resume()
        }
    }
}

