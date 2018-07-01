//
//  ViewController.swift
//  Find It
//
//  Created by d182_oscar_a on 15/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {
    
    let peticion = Peticion() //variable para hacer la peticion a mi API
    let managerUbication = CLLocationManager()
    
    //Agregando coordenadas
    let myLocation = CLLocation(latitude: 40.714353, longitude: -74.005973)
    //************
    
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
    
    let parametroProducto: UITextField = {
        let p = UITextField()
        p.text = "v-neck+sweater"
        p.backgroundColor = UIColor.yellow
        p.translatesAutoresizingMaskIntoConstraints = false
        p.keyboardType = UIKeyboardType.default
        return p
    }()
    
    let labelLatitud: UILabel = {
       let labelLat = UILabel()
        labelLat.text = "???"//40.714353
        labelLat.translatesAutoresizingMaskIntoConstraints = false
        return labelLat
    }()
    
    let labelLongitud: UILabel = {
       let labelLong = UILabel()
        labelLong.text = "???"//-74.005973
        labelLong.translatesAutoresizingMaskIntoConstraints = false
        return labelLong
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managerUbication.delegate = self
        managerUbication.desiredAccuracy = kCLLocationAccuracyBest
        managerUbication.requestWhenInUseAuthorization()
        managerUbication.startUpdatingLocation()
        setupLayout()
        
        
    }
    
    func setupLayout() {
        self.parametroProducto.delegate = self
        view.backgroundColor = UIColor.white
        view.addSubview(registerButton)
        view.addSubview(parametroProducto)
        view.addSubview(productLabel)
        view.addSubview(labelLatitud)
        view.addSubview(labelLongitud)
        
        productLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        
        parametroProducto.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 30).isActive = true
        parametroProducto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: parametroProducto.bottomAnchor, constant: 30).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        labelLatitud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelLatitud.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30).isActive = true
        
        labelLongitud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelLongitud.topAnchor.constraint(equalTo: labelLatitud.bottomAnchor, constant: 30).isActive = true
    }
    
    
    @objc func getStores(){
        peticion.getStores(latitud: myLocation.coordinate.latitude, longitud: myLocation.coordinate.longitude, parametroProducto: parametroProducto)
    }
    
    //Inicia dismiss keyboard..
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parametroProducto.resignFirstResponder() //Renuncia a tu estado de primera ventana.
        return true
    }
    //Termina dismiss keyboard..
    
    //Implementando Ubicacion
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print("Latitud: \(location.coordinate.latitude) longitud: \(location.coordinate.longitude)")
    }
    
}

