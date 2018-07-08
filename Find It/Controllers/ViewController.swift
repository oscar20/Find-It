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
    
    var result : String = "jjjj"
    let peticion = Peticion() //variable para hacer la peticion a mi API
    let managerUbication = CLLocationManager()
    var locationOscar = CLLocation()
    //Variable parciales para guardar la locacion temporal
    var tempLatitud : Double = 0.0
    var tempLongitud : Double = 0.0
    
    //Agregando coordenadas
    let EUlocation = CLLocation(latitude: 40.71435323, longitude: -74.00597345)
    var difLatitud : Double = 0.0
    var difLongitud : Double = 0.0
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
    
    /*let labelLatitud: UILabel = {
       let labelLat = UILabel()
        labelLat.text = "0.0"//40.714353
        labelLat.translatesAutoresizingMaskIntoConstraints = false
        return labelLat
    }()
    
    let labelLongitud: UILabel = {
       let labelLong = UILabel()
        labelLong.text = "0.0"//-74.005973
        labelLong.translatesAutoresizingMaskIntoConstraints = false
        return labelLong
    }()*/
    
    let labelUbicacion: UILabel = {
        let ub = UILabel()
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.text = "Aqui voy a escribir mi ubicacion.."
        ub.textColor = UIColor.white
        ub.backgroundColor = UIColor.gray
        return ub
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managerUbication.delegate = self
        managerUbication.desiredAccuracy = kCLLocationAccuracyBest
        managerUbication.requestWhenInUseAuthorization()
        managerUbication.startUpdatingLocation()
        //managerUbication.distanceFilter = 1

        
        
        //print("LATITUD INICIAL: \(managerUbication.location?.coordinate.latitude)")
        //print("LONGITUD INICIAL: \(managerUbication.location?.coordinate.longitude)")
        
        setupLayout()
    }
    
    func setupLayout() {
        self.parametroProducto.delegate = self
        view.backgroundColor = UIColor.white
        view.addSubview(labelUbicacion)
        view.addSubview(registerButton)
        view.addSubview(parametroProducto)
        view.addSubview(productLabel)
        
        //view.addSubview(labelLatitud)
        //view.addSubview(labelLongitud)
        
        //labelUbicacion.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10).isActive = true
        //labelUbicacion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        labelUbicacion.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //labelUbicacion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        labelUbicacion.topAnchor.constraint(equalTo: view.topAnchor,constant: 90).isActive = true
        //labelUbicacion.widthAnchor.constraint(equalToConstant: 20).isActive = true

        productLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 20).isActive = true
        productLabel.topAnchor.constraint(equalTo: labelUbicacion.bottomAnchor, constant: 100).isActive = true
        
        parametroProducto.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 30).isActive = true
        parametroProducto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: parametroProducto.bottomAnchor, constant: 30).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        //labelLatitud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //labelLatitud.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30).isActive = true
        
        //labelLongitud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //labelLongitud.topAnchor.constraint(equalTo: labelLatitud.bottomAnchor, constant: 30).isActive = true
    }
    
    
    @objc func getStores(){
        if locationOscar.coordinate.latitude != 0.0 || locationOscar.coordinate.longitude != 0.0 {
            peticion.getStoresAlamo(latitud: locationOscar.coordinate.latitude, longitud: locationOscar.coordinate.longitude, parametroProducto: parametroProducto)
            performSegue(withIdentifier: "segue", sender: self)
        }else{
            print("No se puede enviar la peticion con coordenadas de 0.0")
        }
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
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationOscar = locations[0]
        print("LATITUD DE LOCATION MANAGER: \(managerUbication.location?.coordinate.latitude)")
        print("LONGITUD DE LOCATION MANAGER: \(managerUbication.location?.coordinate.longitude)")
        //let locationLatitud = locationOscar.coordinate.latitude
        //let locationLongitud = locationOscar.coordinate.longitude
        tempLatitud = locationOscar.coordinate.latitude
        tempLongitud = locationOscar.coordinate.longitude
        print("LATITUD EN DIDUPDATE: \(tempLatitud)")
        print("LONGITUD EN DIDUPDATE: \(tempLongitud)")
        
        //actualizaCoordenadas(latitudActual: locationLatitud,longitudActual: locationLongitud)
        /*difLatitud = EUlocation.coordinate.latitude - locationOscar.coordinate.latitude
        difLongitud = EUlocation.coordinate.longitude - locationOscar.coordinate.longitude
        
        let sumaLatitud : Double = locationOscar.coordinate.latitude + difLatitud
        let sumaLongitud : Double = locationOscar.coordinate.longitude + difLongitud
        
        labelLatitud.text = String(format: "%.6f", sumaLatitud) //String(format: "%f", locationOscar.coordinate.latitude)
        labelLongitud.text = String(sumaLongitud) //String(format: "%f", locationOscar.coordinate.longitude)
        //print("Latitud: \(locationOscar.coordinate.latitude) longitud: \(locationOscar.coordinate.longitude)")
        //print("Suma de latitudes y longitudes: \(sumaLatitud) : \(sumaLongitud)")
        //print("La diferencia de latitud es: \(difLatitud) y la diferencia de longitud es: \(difLongitud)")
        print("Latitud: \(locationOscar.coordinate.latitude)")
        print("Diferencia: \(difLatitud)")
        print("Suma: \(sumaLatitud)")*/
    }
    
    func actualizaCoordenadas(latitudActual: Double, longitudActual: Double){
        print("LAT ACTUAL: \(latitudActual) LONG ACTUAL: \(longitudActual)")
        print("TEMP LAT: \(tempLatitud) TEMP LONG: \(tempLongitud)")
        /*let diferenciaLatitudes = latitudActual - tempLatitud
        let diferenciaLongitudes = longitudActual - tempLongitud
        print("Diferencia de latitud:\(diferenciaLatitudes), longitudes: \(diferenciaLongitudes)")
        print("EULOCATION LATITUD: \(Double(EUlocation.coordinate.latitude) + diferenciaLatitudes)")*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultadosViewController = segue.destination as! resultadosViewController
        resultadosViewController.labelSecondController.text = result
    }
    
}

