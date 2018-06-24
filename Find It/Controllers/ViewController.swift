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
        btn.addTarget(self, action: #selector(recuperaDatos), for: .touchUpInside)
         return btn
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(registerButton)
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func recuperaDatos(){
        print("recuperando datos.....")
        let urlString = "https://api.goodzer.com/products/v0.1/location_details/?locationId=ffy5Pc7R&apiKey=4ee7cdf8c6a05e6f91f8077f3bd003ba"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            print("Recuperando datos...")
        
            guard let data = data else {return}
            
        /*let datosRecuperados = String(data: data, encoding: .utf8)
        print(datosRecuperados)*/
            
        //Parseo de Json
            do {
                let tienda = try JSONDecoder().decode(Tienda.self, from: data)
                print(tienda.status)
            }catch let error{
                print("Error:", error)
            }
                
            
        }.resume()
        
        
    }



}

