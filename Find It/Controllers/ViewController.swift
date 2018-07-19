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
   
    //...........Elementos de vista...........//
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    //.......Terminan elementos de vista......//
    
    //.................Variable...............//
    let peticion = Peticion() //variable para hacer la peticion a mi API
    final let apiKey = ""
    let identificadorCell = "rowID"
    var storeArray : [ProductStore] = []
    let managerUbication = CLLocationManager()
    var locationOscar = CLLocation()
    var miLatitud : String = String()
    var miLongitud : String = String()
    
    //.....Variable que necesito para trabajar con mis coordenadas...
    var EULocationLatitud : Double = 40.71435323
    var EULocationLongitud : Double = -74.00597345
    let EUlocation = CLLocation(latitude: 40.71435323, longitude: -74.00597345)
    var latitud : Double = Double()
    var longitud : Double = Double()
    var temporalLatitud : Double = Double()
    var temporalLongitud : Double = Double()
    
    //............Terminan variables.........//

    override func viewDidLoad() {
        super.viewDidLoad()
        managerUbicationSetup()
        searchBarSetup()
        setupCollectionView()
        setupCollectionViewGrid()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    //........Configuraciion de mi barra de busqueda..........//
    func searchBarSetup(){
        searchBar.delegate = self
        searchBar.placeholder = "Ingresa tu producto aquí..."
        searchBar.barStyle = UIBarStyle.default
        searchBar.keyboardType = UIKeyboardType.alphabet
        searchBar.layer.cornerRadius = 5.0
                
    }
    //.....Terminan configuracion de barra de busqueda.......//
    
    //........Configuracion de CoreLocation........//
    func managerUbicationSetup(){
        managerUbication.delegate = self
        managerUbication.desiredAccuracy = kCLLocationAccuracyBest
        managerUbication.requestWhenInUseAuthorization()
        managerUbication.startUpdatingLocation()
        latitud = (managerUbication.location?.coordinate.latitude)!
        longitud = (managerUbication.location?.coordinate.longitude)!
    }
    //.....Termina configuracion de CoreLocation....//
    
    //.....Enviar peticion cada que cambia el texto escrito en searchBar......//

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        storeArray = []
        let miProductoVacio = [Product(id: nil, image: nil, original_price: nil, price: 0.00, title: nil, url: nil)]
        let textSearchBar = searchText
        let textSearchBar_trimmed  = textSearchBar.trimmingCharacters(in: .whitespaces) //Recorto la cadena.
        let formattingText = textSearchBar_trimmed.replacingOccurrences(of: " ", with: "+") //Reemplazando espacios en blanco.
        if formattingText.isEmpty{
            print("Empty string...")
            storeArray = [ProductStore(id: nil, locations: nil, locations_found: nil, name: "No se encontraron productos..", products: miProductoVacio, products_found: nil, realtime_availability: nil, website: "")]
            self.collectionView.reloadData()
        }else{
            let urlString = "https://api.goodzer.com/products/v0.1/search_stores/?query=\(formattingText)&lat=40.714353&lng=-74.005973&radius=5&priceRange=30:120&apiKey=\(apiKey)" //Armo mi URL para la peticion.
            let url = URL(string: urlString)
            print(urlString)
            Alamofire.request(url!).responseData{ (dataResponse) in
                if let err = dataResponse.error{
                    print("Hubo un error", err)
                    return
                }
                guard let data = dataResponse.data else {return }
                do{
                    let peticionProducto = try JSONDecoder().decode(PeticionProducto.self, from: data)
                    if peticionProducto.stores_found == 0 || peticionProducto.stores_found == nil{
                        self.storeArray = [ProductStore(id: nil, locations: nil, locations_found: nil, name: "No se encontraron productos...", products: miProductoVacio, products_found: nil, realtime_availability: nil, website: "")]
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.myLabel.text = storeArray[indexPath.row].products?.first?.title
        cell.webSite.text = storeArray[indexPath.row].name
        
        obtenerImagenConURL(objetoStore: (storeArray[indexPath.row].products?.first)!){ (imagenRecuperada, error) in
            cell.imagenProducto.backgroundColor = UIColor.clear
            cell.imagenProducto.layer.masksToBounds = true
            cell.imagenProducto.layer.cornerRadius = 5.0
            cell.imagenProducto.layer.borderWidth = 0.7
            cell.imagenProducto.layer.borderColor = UIColor(red: 18/255, green: 113/255, blue: 115/255, alpha: 1.0).cgColor
            cell.imagenProducto.contentMode = UIViewContentMode.scaleAspectFill
            cell.imagenProducto.image = imagenRecuperada
        }
        cell.imagenUbicacion.image = UIImage(named: "ubicacion2")
        cell.precioLabel.text = "$\(String(format: "%.2f", (storeArray[indexPath.row].products?.first?.price)!))"
        return cell
    }
    //.......Terminan metodos de collection View....//

    //.......Metodo para diseño de collection View......//
    func setupCollectionViewGrid(){
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = CGFloat(7.0)
        flow.itemSize.height = CGFloat(80.0)
    }
    //....Termina metodo de diseño de collection View....//
    
    //........Metodo para ir a otra vista al hacer click en icono ubicacion.....//

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "UbicacionViewController", sender: indexPath)
        
    }
    
    //..Termina Metodo para ir a otra vista al hacer click en icono ubicacion.....//
    
    //.......Inicia funcion para obtener imagen con URL.......//
    func obtenerImagenConURL(objetoStore : Product, completionHandler: @escaping (UIImage?, Error?) -> () ){
        if let urlImagen = objetoStore.image{
            //print("NO NIL")
            //print(urlImagen)
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
    
    //.....Metodo que actualiza la ubicacion....//
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationOscar = locations[0]
        print("LATITUD ES: \(latitud)")
        print("LONGITUD ES: \(longitud)")
        temporalLatitud = locationOscar.coordinate.latitude - latitud
        temporalLongitud = locationOscar.coordinate.longitude - longitud
        print("TEMPORAL LATITUD ES: \(temporalLatitud)")  //DEBE DE DAR CASI 0
        print("TEMPORAL LONGITUD ES: \(temporalLongitud)") //DEBE DE DAR CASI 0
        EULocationLatitud = EUlocation.coordinate.latitude + temporalLatitud
        EULocationLongitud = EUlocation.coordinate.longitude + temporalLongitud
        print("EU LATITUD ES: \(EULocationLatitud)")
        print("EU LONGITUD ES: \(EULocationLongitud)")
        latitud = locationOscar.coordinate.latitude
        longitud = locationOscar.coordinate.longitude
        
        
        /*CLGeocoder().reverseGeocodeLocation(locationOscar) { (place, error) in  //Para obtener la direccion dadas las coordenadas geograficas
            if error != nil {
                print("There is an error!!")
                //print(error)
            }else{
                if let myplace = place?[0]{
                    self.labelDireccion.text = "\(myplace.name!)"
                    self.miLatitud = "\(myplace.name!) \(myplace.thoroughfare!) \(myplace.country!)"
                    self.miLongitud = myplace.name!
                }
            }
            
        }*/
    }
    //.......Termina metodo que actualiza la ubicacion....//

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndexPath = sender as? NSIndexPath
        let ubicacionViewController = segue.destination as! UbicacionViewController
        ubicacionViewController.miCadenaOrigen = String(EULocationLatitud) //storeArray[(selectedIndexPath?.row)!].website as! String
        ubicacionViewController.miCadenaDestino = String(EULocationLongitud)  //storeArray[(selectedIndexPath?.row)!].name as! String
    }
    
}
