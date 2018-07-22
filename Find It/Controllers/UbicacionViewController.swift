//
//  UbicacionViewController.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 15/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit
import GoogleMaps


class UbicacionViewController: UIViewController {
    
    
    var miCadenaOrigen = String()
    var miCadenaDestino = String()
    
    let labelOrigen : UILabel = {
       let lbl = UILabel()
        lbl.text = " Tu origen..."
        lbl.font = UIFont.italicSystemFont(ofSize: 14.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = CGFloat(5.0)
        lbl.layer.borderWidth = CGFloat(1.0)
        lbl.layer.borderColor = UIColor.black.cgColor
        return lbl
    }()
    
    let labelDestino : UILabel = {
       let lbl = UILabel()
        lbl.text = " Tu destino..."
        lbl.font = UIFont.italicSystemFont(ofSize: 14.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor(white: 1, alpha: 0.5)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = CGFloat(5.0)
        lbl.layer.borderWidth = CGFloat(0.6)
        lbl.layer.borderColor = UIColor.black.cgColor
        return lbl
    }()
    
    let imagenOrigen : UIImageView = {
       let imagenOrigen = UIImageView()
        imagenOrigen.image = UIImage(named: "iconoOrigen")
        imagenOrigen.translatesAutoresizingMaskIntoConstraints = false
        return imagenOrigen
    }()
    
    let imagenDestino : UIImageView = {
       let imagenDestino = UIImageView()
        imagenDestino.image = UIImage(named: "iconoDestino")
        imagenDestino.translatesAutoresizingMaskIntoConstraints = false
        return imagenDestino
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("")
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Mi titulo"
        marker.snippet = "Mi snippet"
        marker.map = mapView
        
        view.addSubview(labelOrigen)
        view.addSubview(labelDestino)
        view.addSubview(imagenOrigen)
        view.addSubview(imagenDestino)
        
        imagenOrigen.topAnchor.constraint(equalTo: view.topAnchor, constant: 37).isActive = true
        imagenOrigen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        imagenDestino.topAnchor.constraint(equalTo: imagenOrigen.bottomAnchor, constant: 15).isActive = true
        imagenDestino.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19).isActive = true
        
        labelOrigen.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        labelOrigen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        labelOrigen.leadingAnchor.constraint(equalTo: imagenOrigen.trailingAnchor, constant: 10).isActive = true
        
        labelDestino.topAnchor.constraint(equalTo: labelOrigen.bottomAnchor, constant: 10).isActive = true
        labelDestino.leadingAnchor.constraint(equalTo: imagenDestino.trailingAnchor,constant: 9).isActive = true
        labelDestino.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        /*labelOrigen.text = miCadenaOrigen
        labelDestino.text = miCadenaDestino
        
        print("MI CADENA ORIGEN ES: \(miCadenaOrigen)")
        print("MI CADENA DESTINO ES: \(miCadenaDestino)")*/
    }
    
    override func loadView() {
        
    }

}
