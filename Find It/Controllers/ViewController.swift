//
//  ViewController.swift
//  Find It
//
//  Created by d182_oscar_a on 15/06/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate,UISearchBarDelegate {
    
    //......Elementos de vista......//
    let productLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "¿Qué producto estás buscando?"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    //.......Terminan elementos de vista......//
    
    //.................Variable...............//
    let peticion = Peticion() //variable para hacer la peticion a mi API
    final let apiKey = ""
    let identificadorCell = "rowID"
    var storeArray : [ProductStore] = []

    var result : String = "jjjj"
    let managerUbication = CLLocationManager()
    var locationOscar = CLLocation()
    //Variable parciales para guardar la locacion temporal
    var tempLatitud : Double = 0.0
    var tempLongitud : Double = 0.0
    
    //Agregando coordenadas
    let EUlocation = CLLocation(latitude: 40.71435323, longitude: -74.00597345)
    var difLatitud : Double = 0.0
    var difLongitud : Double = 0.0
    
    //............Terminan variables.........//

    override func viewDidLoad() {
        super.viewDidLoad()
        //managerUbicationSetup()
        searchBarSetup()
        setupLayout()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //........Configuraciion de mi barra de busqueda..........//
    func searchBarSetup(){
        searchBar.delegate = self
        searchBar.placeholder = "Ingresa tu producto aquí..."
        searchBar.barStyle = UIBarStyle.default
    }
    //.....Terminan configuracion de barra de busqueda.......//
    
    //........Configuracion de CoreLocation........//
    func managerUbicationSetup(){
        managerUbication.delegate = self
        managerUbication.desiredAccuracy = kCLLocationAccuracyBest
        managerUbication.requestWhenInUseAuthorization()
        managerUbication.startUpdatingLocation()
    }
    //.....Termina configuracion de CoreLocation....//
    
    //.......Configuracion de vistas.......//
    func setupLayout() {
        view.backgroundColor = UIColor.white
        view.addSubview(productLabel)
        productLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -15).isActive = true
    }
    //.......Termina configuracion de vistas......//
    
    //.....Enviar peticion cada que cambia el texto escrito en searchBar......//

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        storeArray = []
        let miProductoVacio = [Product(id: nil, image: nil, original_price: nil, price: nil, title: nil, url: nil)]
        let textSearchBar = searchText
        let textSearchBar_trimmed  = textSearchBar.trimmingCharacters(in: .whitespaces) //Recorto la cadena.
        let formattingText = textSearchBar_trimmed.replacingOccurrences(of: " ", with: "+") //Reemplazando espacios en blanco.
        if formattingText.isEmpty{
            print("Empty string...")
            storeArray = [ProductStore(id: nil, locations: nil, locations_found: nil, name: "Sin nombre", products: miProductoVacio, products_found: nil, realtime_availability: nil, website: "Sin website")]
            self.collectionView.reloadData()
        }else{
            let urlString = "https://api.goodzer.com/products/v0.1/search_stores/?query=\(formattingText)&lat=40.714353&lng=-74.005973&radius=5&priceRange=30:120&apiKey=\(apiKey)" //Armo mi URL para la peticion.
            let url = URL(string: urlString)
            Alamofire.request(url!).responseData{ (dataResponse) in
                if let err = dataResponse.error{
                    print("Hubo un error", err)
                    return
                }
                guard let data = dataResponse.data else {return }
                do{
                    let peticionProducto = try JSONDecoder().decode(PeticionProducto.self, from: data)
                    if peticionProducto.stores_found == 0 || peticionProducto.stores_found == nil{
                        self.storeArray = [ProductStore(id: nil, locations: nil, locations_found: nil, name: "Sin nombre", products: miProductoVacio, products_found: nil, realtime_availability: nil, website: "Sin website")]
                        self.collectionView.reloadData()
                    }else{
                        print("Results", peticionProducto.status!)
                        peticionProducto.stores?.forEach({ (store) in
                            print("NAME:\(store.name!)\n")
                            self.storeArray.append(store)
                            self.collectionView.reloadData()
                        })
                    }
                }catch let decodeError{
                    print("Error: ", decodeError)
                }
            }
        }
    }
    //............Termina peticion.........//
    
    //......Inicia dismiss keyboard......//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //.......Termina dismiss keyboard....//
    
    //.......Metodos collectionView.....
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.myLabel.text = storeArray[indexPath.row].name
        cell.webSite.text = storeArray[indexPath.row].website
        
        obtenerImagenConURL(objetoStore: (storeArray[indexPath.row].products?.first)!){ (imagenRecuperada, error) in
            cell.imagenProducto.image = imagenRecuperada
        }
        cell.imagenUbicacion.image = UIImage(named: "ubicacion")
        return cell
    }
    //.......Terminan metodos de collection View....//
    
    //.......Inicia funcion para obtener imagen con URL.......//
    func obtenerImagenConURL(objetoStore : Product, completionHandler: @escaping (UIImage?, Error?) -> () ){
        if let urlImagen = objetoStore.image{
            print("NO NIL")
            print(urlImagen)
            let urlImagenPeticion = URL(string: urlImagen)
            Alamofire.request(urlImagenPeticion!).responseData { (responseData) in
                if let error = responseData.error{
                    print("No se pudo cargar la imagen \(error)")
                }
                guard let data = responseData.data else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async(execute: {
                    completionHandler(image,nil)
                })
            }
        }else{
            print("nil")
            let imagenVacia = UIImage(named: "noDisponible")
            completionHandler(imagenVacia,nil)
        }
        
    }
    //.......Termina funcion para obtener imagen con URL.......//
    
    /*@objc func getStores(){
        if locationOscar.coordinate.latitude != 0.0 || locationOscar.coordinate.longitude != 0.0 {
            peticion.getStoresAlamo(latitud: locationOscar.coordinate.latitude, longitud: locationOscar.coordinate.longitude, parametroProducto: parametroProducto)
            performSegue(withIdentifier: "segue", sender: self)
        }else{
            print("No se puede enviar la peticion con coordenadas de 0.0")
        }
    }*/
    
    //Implementando Ubicacion
   
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
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
    }*/
    
    /*func actualizaCoordenadas(latitudActual: Double, longitudActual: Double){
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
    }*/
    
}

