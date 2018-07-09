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

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate,UISearchBarDelegate {
    
    //......Elementos de vista......//
    let productLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "¿Qué producto estás buscando?"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var miTableView: UITableView!
    /*let parametroProducto: UITextField = {
        let p = UITextField()
        p.text = "v-neck+sweater"
        p.backgroundColor = UIColor.yellow
        p.translatesAutoresizingMaskIntoConstraints = false
        p.keyboardType = UIKeyboardType.default
        return p
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
        
    }()*/
    //.......Terminan elementos de vista......//
    
    //.................Variable...............//
    let peticion = Peticion() //variable para hacer la peticion a mi API
    final let apiKey = "4ee7cdf8c6a05e6f91f8077f3bd003ba"
    let identificadorCell = "rowID"
    var storeArray : [String] = []

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
    
    /*let labelUbicacion: UILabel = {
        let ub = UILabel()
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.text = "Aqui voy a escribir mi ubicacion.."
        ub.textColor = UIColor.white
        ub.backgroundColor = UIColor.gray
        return ub
    }()*/

    override func viewDidLoad() {
        super.viewDidLoad()
        managerUbicationSetup()
        searchBarSetup()
        setupLayout()
        setupTableView()

    }
    
    func setupTableView() {
        miTableView.delegate = self
        miTableView.dataSource = self
        miTableView.register(UITableViewCell.self, forCellReuseIdentifier: identificadorCell)
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
        //self.parametroProducto.delegate = self
        view.backgroundColor = UIColor.white
        //view.addSubview(registerButton)
        //view.addSubview(parametroProducto)
        view.addSubview(productLabel)
        productLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -15).isActive = true
        
        /*parametroProducto.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30).isActive = true
        parametroProducto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: parametroProducto.bottomAnchor, constant: 30).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true*/
    }
    //.......Termina configuracion de vistas......//
    
    //.....Enviar peticion cada que cambia el texto escrito en searchBar......//

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        storeArray = []
        let textSearchBar = searchText
        let textSearchBar_trimmed  = textSearchBar.trimmingCharacters(in: .whitespaces) //Recorto la cadena.
        let formattingText = textSearchBar_trimmed.replacingOccurrences(of: " ", with: "+") //Reemplazando espacios en blanco.
        if formattingText.isEmpty{
            print("Empty string...")
            storeArray = ["No se encontraron elementos..."]
            self.miTableView.reloadData()
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
                        self.storeArray = ["No se encontraron elementos..."]
                        self.miTableView.reloadData()
                    }else{
                        print("Results", peticionProducto.status!)
                        peticionProducto.stores?.forEach({ (store) in
                            print("NAME:\(store.name!)\n")
                            self.storeArray.append(store.name!)
                            self.miTableView.reloadData()
                            /*store.products?.forEach({ (producto) in
                                print("URL:\(producto.url!)")
                            })*/
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
    
    //.......Metodos de tableViewController.......//
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identificadorCell, for: indexPath)
        cell.textLabel?.text = storeArray[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    //.......Termina metodos de tableViewController.....//
    
    
    
    
    
    
    /*@objc func getStores(){
        if locationOscar.coordinate.latitude != 0.0 || locationOscar.coordinate.longitude != 0.0 {
            peticion.getStoresAlamo(latitud: locationOscar.coordinate.latitude, longitud: locationOscar.coordinate.longitude, parametroProducto: parametroProducto)
            performSegue(withIdentifier: "segue", sender: self)
        }else{
            print("No se puede enviar la peticion con coordenadas de 0.0")
        }
    }*/
    
    
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parametroProducto.resignFirstResponder() //Renuncia a tu estado de primera ventana.
        return true
    }*/
    //Termina dismiss keyboard..
    
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

