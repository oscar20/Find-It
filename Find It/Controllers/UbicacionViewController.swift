//
//  UbicacionViewController.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 15/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

class UbicacionViewController: UIViewController {
    
    let keyMapa = ""
    var puntoLatitud = CLLocationDegrees()
    var puntoLongitud = CLLocationDegrees()
    var latitudTienda = CLLocationDegrees()
    var longitudTienda = CLLocationDegrees()
    
    let labelOrigen : UILabel = {
       let lbl = UILabel()
        lbl.text = " "
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
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
        lbl.text = " "
        lbl.lineBreakMode = NSLineBreakMode.byCharWrapping
        lbl.numberOfLines = 2
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
        setupMapa()
        setupLayout()
        print("LATITUD TIENDA ES: \(latitudTienda)")
        print("LONGITUD TIENDA ES: \(longitudTienda)")
        
        
        
    }
    
    override func loadView() {
        let miUbicacion : CLLocation = CLLocation(latitude: puntoLatitud, longitude: puntoLongitud)
        let ubicacionTienda : CLLocation = CLLocation(latitude: latitudTienda, longitude: longitudTienda)
        
        CLGeocoder().reverseGeocodeLocation(miUbicacion) { (place, error) in  //Para obtener la direccion dadas las coordenadas geograficas
             if error != nil {
                 print("There is an error!!")
                 //print(error)
             }else{
                 if let myplace = place?[0]{

                    self.labelOrigen.text = " \(myplace.thoroughfare!) \(myplace.subThoroughfare!), \(myplace.subLocality!), \(myplace.postalCode!) \(myplace.locality!), \(myplace.isoCountryCode!) "
                 }
             }
        }
        CLGeocoder().reverseGeocodeLocation(ubicacionTienda) { (place, error) in  //Para obtener la direccion dadas las coordenadas geograficas
            if error != nil {
                print("There is an error!!")
            }else{
                if let myplace = place?[0]{
                    self.labelDestino.text = " \(myplace.thoroughfare!) \(myplace.subThoroughfare!), \(myplace.subLocality!), \(myplace.postalCode!) \(myplace.locality!), \(myplace.isoCountryCode!) "
                }
            }
        }
    }
    
    func setupLayout(){
        view.addSubview(labelOrigen)
        view.addSubview(labelDestino)
        view.addSubview(imagenOrigen)
        view.addSubview(imagenDestino)
        
        imagenOrigen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imagenOrigen.centerYAnchor.constraint(equalTo: labelOrigen.centerYAnchor).isActive = true
        
        imagenDestino.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19).isActive = true
        imagenDestino.centerYAnchor.constraint(equalTo: labelDestino.centerYAnchor).isActive = true

        
        labelOrigen.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        labelOrigen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        labelOrigen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        labelDestino.topAnchor.constraint(equalTo: labelOrigen.bottomAnchor, constant: 10).isActive = true
        labelDestino.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40).isActive = true
        labelDestino.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
    }
    
    func setupMapa(){
        GMSServices.provideAPIKey(keyMapa)
        //let camera = GMSCameraPosition.camera(withLatitude: 19.420746, longitude: -99.177288, zoom: 12.0)
        let miCoordenada = CLLocationCoordinate2DMake(latitudTienda, longitudTienda)
        let camera2 = GMSCameraPosition.camera(withTarget: miCoordenada, zoom: 15.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), camera: camera2)
        view = mapView
        
        let position = CLLocationCoordinate2D(latitude: latitudTienda, longitude: longitudTienda)
        let markerTienda = GMSMarker(position: position)
        markerTienda.title = "Mi tienda"
        markerTienda.map = mapView
        markerTienda.icon = UIImage(named: "ubicacionOrigen")

        
        
        let markerUbicacionActual = GMSMarker()
        markerUbicacionActual.position = CLLocationCoordinate2D(latitude: puntoLatitud, longitude: puntoLongitud)
        markerUbicacionActual.title = "Mi ubicacion"
        markerUbicacionActual.snippet = "Mi ubicacion snippet"
        markerUbicacionActual.icon = UIImage(named: "ubicacionDestino")
        markerUbicacionActual.map = mapView
        
    //.......
        
        let origen = "\(puntoLatitud),\(puntoLongitud)"
        let destino = "\(latitudTienda),\(longitudTienda)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origen)&destination=\(destino)&key=\(keyMapa)"
        var routes : [JSON] = []
        
        Alamofire.request(url).responseJSON { (response) in
            //print(response.response!)
            print("####RESPONSE \(response.request!)")
            //print(response.result)
            //print(response.data)
            do{
                let json = try JSON(data: response.data!)
                routes = json["routes"].arrayValue
            }catch{
                print("Hubo un error al obtener datos para ruta")
            }
            
            for route in routes {
                let routeOverViewPolyline = route["overview_polyline"].dictionary
                let points = routeOverViewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                //print("######  PATH: \(path)")
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = UIColor.red
                polyline.strokeWidth = 4
                polyline.map = mapView
            }
        }
        
    //.......
        
    }

}
