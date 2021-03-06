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

class UbicacionViewController: UIViewController{
    
    
    //..........Variables a considerar........//
    let keyMapa = ""
    var puntoLatitud = CLLocationDegrees()
    var puntoLongitud = CLLocationDegrees()
    var latitudTienda = CLLocationDegrees()
    var longitudTienda = CLLocationDegrees()
    var mapView = GMSMapView()
    var nombreTienda = String()
    //.............Terminan variable..........//
    
    //........Elementos de interfaz grafica........//
    let labelOrigen : UILabel = {
       let lbl = UILabel()
        lbl.text = " "
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
        lbl.font = UIFont.italicSystemFont(ofSize: 14.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor(white: 1, alpha: 0.8)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = CGFloat(5.0)
        lbl.layer.borderWidth = CGFloat(1.0)
        lbl.layer.borderColor = UIColor(red: 39/255, green: 96/255, blue: 128/255, alpha: 1.0).cgColor
        return lbl
    }()
    
    let labelDestino : UILabel = {
       let lbl = UILabel()
        lbl.text = " "
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
        lbl.font = UIFont.italicSystemFont(ofSize: 14.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor(white: 1, alpha: 0.8)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = CGFloat(5.0)
        lbl.layer.borderWidth = CGFloat(0.6)
        lbl.layer.borderColor = UIColor(red: 39/255, green: 96/255, blue: 128/255, alpha: 1.0).cgColor
        return lbl
    }()
    
    let imagenOrigen : UIImageView = {
       let imagenOrigen = UIImageView()
        imagenOrigen.image = UIImage(named: "iconoOrigen")
        imagenOrigen.translatesAutoresizingMaskIntoConstraints = false
        imagenOrigen.layer.cornerRadius = 5.0
        return imagenOrigen
    }()
    
    let imagenDestino : UIImageView = {
       let imagenDestino = UIImageView()
        imagenDestino.image = UIImage(named: "iconoDestino")
        imagenDestino.translatesAutoresizingMaskIntoConstraints = false
        return imagenDestino
    }()
    
    let uiSegmentedControl : UISegmentedControl = {
        let segmented = UISegmentedControl(items: [UIImage(named: "coche")!,UIImage(named: "bici")!,UIImage(named: "caminar")!])
        segmented.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmented.tintColor = UIColor(red: 39/255, green: 96/255, blue: 128/255, alpha: 1.0)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        return segmented
    }()
    
    let imageView : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor(red: 241/255, green: 250/255, blue: 238/255, alpha: 1.0)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 4.0
        return image
    }()
    //..........Terminan elementos de interfaz.........//
    
    //.........Carga de mapa y de elementos de interfaz........//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapa()
        setupLayout()
       
        print("LATITUD TIENDA ES: \(latitudTienda)")
        print("LONGITUD TIENDA ES: \(longitudTienda)")
    }
    //......Termina carga de mapa y elementos..............//
    
    //............Se hace la conversion de coordenadas a texto..........//
    override func loadView() {
        conversionCoordenadas()
    }
    //..............Termina la conversion de coordenadas.............//
    
    //.......Funcion para conversion de coordenadas.........//
    func conversionCoordenadas(){
        let miUbicacion : CLLocation = CLLocation(latitude: puntoLatitud, longitude: puntoLongitud)
        let ubicacionTienda : CLLocation = CLLocation(latitude: latitudTienda, longitude: longitudTienda)
        
        CLGeocoder().reverseGeocodeLocation(miUbicacion) { (place, error) in
            if error != nil {
                print("There is an error!!")
                //print(error)
            }else{
                if let myplace = place?[0]{
                    self.labelOrigen.text = " \(myplace.thoroughfare!) \(myplace.subThoroughfare!), \(myplace.subLocality!), \(myplace.locality!)"
                }
            }
        }
        CLGeocoder().reverseGeocodeLocation(ubicacionTienda) { (place, error) in
            if error != nil {
                print("There is an error!!")
            }else{
                if let myplace = place?[0]{
                    self.labelDestino.text = " \(myplace.thoroughfare!) \(myplace.subThoroughfare!), \(myplace.subLocality!), \(myplace.locality!)"
                }
            }
        }
    }
    //.........Termina funcion de conversion de coordenadas.........//
    
    //.........Funcion para integrar componenes de vista...........//
    func setupLayout(){
        
        view.addSubview(imageView)
        view.addSubview(labelOrigen)
        view.addSubview(labelDestino)
        view.addSubview(imagenOrigen)
        view.addSubview(imagenDestino)
        view.addSubview(uiSegmentedControl)
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: labelDestino.bottomAnchor, constant: 5).isActive = true
        
        imagenOrigen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imagenOrigen.centerYAnchor.constraint(equalTo: labelOrigen.centerYAnchor).isActive = true
        imagenOrigen.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        imagenOrigen.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        
        imagenDestino.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9).isActive = true
        imagenDestino.centerYAnchor.constraint(equalTo: labelDestino.centerYAnchor).isActive = true
        imagenDestino.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        imagenDestino.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        
        labelOrigen.topAnchor.constraint(equalTo: view.topAnchor, constant: 66).isActive = true
        labelOrigen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        labelOrigen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35).isActive = true
        
        labelDestino.topAnchor.constraint(equalTo: labelOrigen.bottomAnchor, constant: 10).isActive = true
        labelDestino.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 35).isActive = true
        labelDestino.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        uiSegmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        uiSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        uiSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        
    }
    //..........Termina funcion de integracion de componentes.........//
    
    //..............Funcion para pintar mapa............//
    func setupMapa(){
        
        let cameraTienda = GMSCameraPosition.camera(withLatitude: latitudTienda, longitude: longitudTienda, zoom: 17, bearing: 10, viewingAngle: 5)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), camera: cameraTienda)
        
        mapView.setMinZoom(10.0, maxZoom: 20.0)
        view = mapView
        setupMarkersMap() //Llamado a funcion para pintar markers en mapa
    }
    //...........Termina funcion para pintar mapa .......//
    
    //.........Funcion para crear marcadores en mapa.......//
    func setupMarkersMap(){
        
        let posicionMarcadorTienda = CLLocationCoordinate2D(latitude: latitudTienda, longitude: longitudTienda)
        let marcadorTienda = GMSMarker(position: posicionMarcadorTienda)
        marcadorTienda.title = "\(nombreTienda)"
        marcadorTienda.map = mapView
        marcadorTienda.icon = UIImage(named: "ubicacionOrigen")
        
        let posicionMarcadorUbicacion = GMSMarker()
        posicionMarcadorUbicacion.position = CLLocationCoordinate2D(latitude: puntoLatitud, longitude: puntoLongitud)
        posicionMarcadorUbicacion.title = "Tu ubicación"
        posicionMarcadorUbicacion.icon = UIImage(named: "ubicacionDestino")
        posicionMarcadorUbicacion.map = mapView
    }
    //.........Termina funcion para crear marcadores.......//
    
    //..............Funcion para pintar ruta en mapa.............//
    func obtenerRuta(mapa : GMSMapView, mode : String){
        
        let origen = "\(puntoLatitud),\(puntoLongitud)"
        let destino = "\(latitudTienda),\(longitudTienda)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origen)&destination=\(destino)&mode=\(mode)&key=\(keyMapa)"
        var routes : [JSON] = []
        Alamofire.request(url).responseJSON { (response) in
            print("####RESPONSE \(response.request!)")
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
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = UIColor.red
                polyline.strokeWidth = 4
                polyline.map = mapa
            }
        }
    }
    //..........Termina funcion para pintar ruta en mapa..........//
    
    //.........Funcion que hace el cambio de ruta en mapa.........//
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.clear()
            setupMarkersMap()
            obtenerRuta(mapa: mapView, mode: "driving")
        case 1:
            mapView.clear()
            setupMarkersMap()
            obtenerRuta(mapa: mapView, mode: "bicycling")
        case 2:
            mapView.clear()
            setupMarkersMap()
            obtenerRuta(mapa: mapView, mode: "walking")
        default:
            break }
    }
    //........Termina funcion que hace el cambio de ruta.........//
    
}
