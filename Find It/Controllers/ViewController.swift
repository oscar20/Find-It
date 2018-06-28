//
//  ViewController.swift
//  Find It
//
//  Created by d182_oscar_a on 15/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    
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
        p.keyboardType = UIKeyboardType.default
        return p
    }()
    
    let labelLatitud: UILabel = {
       let labelLat = UILabel()
        labelLat.text = "Latitud"
        labelLat.translatesAutoresizingMaskIntoConstraints = false
        return labelLat
    }()
    
    let labelLongitud: UILabel = {
       let labelLong = UILabel()
        labelLong.text = "Longitud"
        labelLong.translatesAutoresizingMaskIntoConstraints = false
        return labelLong
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parametro.delegate = self
        view.backgroundColor = UIColor.white
        view.addSubview(registerButton)
        view.addSubview(parametro)
        view.addSubview(productLabel)
        view.addSubview(labelLatitud)
        view.addSubview(labelLongitud)
        
        productLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        
        parametro.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 30).isActive = true
        parametro.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: parametro.bottomAnchor, constant: 30).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        labelLatitud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelLatitud.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30).isActive = true
        
        labelLongitud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelLongitud.topAnchor.constraint(equalTo: labelLatitud.bottomAnchor, constant: 30).isActive = true
        
    }
    
    
    @objc func getStores(){
        print("Running getStores...")
        guard let textTextField = parametro.text else {return}//Valido que mi TextField contenga una cadena.
        let textTextField_trimmed  = textTextField.trimmingCharacters(in: .whitespaces) //Recorto la cadena.
        let formattingText = textTextField_trimmed.replacingOccurrences(of: " ", with: "+") //Reemplazando espacios en blanco.
        if formattingText.isEmpty{
            print("Empty string...")
        }else{
            print("The parameter is:\(formattingText).")
            let latitud = "40.714353"
            let longitud = "-74.005973"
            let apiKey = ""
            let urlString = "https://api.goodzer.com/products/v0.1/search_stores/?query=\(formattingText)&lat=\(latitud)&lng=\(longitud)&radius=5&priceRange=30:120&apiKey=\(apiKey)" //Armo mi URL para la peticion.
            let url = URL(string: urlString) //Ejecuto mi peticion
            labelLatitud.text = latitud
            labelLongitud.text = longitud
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                print("Getting stores...")
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
    
    //Dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parametro.resignFirstResponder() //Renuncia a tu estado de primera ventana.
        return true
    }
    
    
    /*@objc func recuperaDatos(){
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
     */
}

