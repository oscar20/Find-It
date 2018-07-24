//
//  DetalleProductoViewController.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 23/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit
import CoreLocation

class DetalleProductoViewController: UIViewController {

    @IBOutlet weak var imagenProducto: UIImageView!
    @IBOutlet weak var nombreProducto: UILabel!
    @IBOutlet weak var precioProducto: UILabel!
    @IBOutlet weak var tienda: UILabel!
    @IBOutlet weak var webSite: UILabel!
    
    var puntoLatitud = CLLocationDegrees()
    var puntoLongitud = CLLocationDegrees()
    var latitudTienda = CLLocationDegrees()
    var longitudTienda = CLLocationDegrees()
    
    var imagenMProducto = UIImageView()
    var nombreMiProducto = String()
    var precioMiProducto = Double()
    var MiwebSite = String()
    var nombreMiTienda = String()

    @IBOutlet weak var botonMapa: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreProducto.text = nombreMiProducto
        precioProducto.text =  "$ \(String(precioMiProducto))"
        tienda.text = "Tienda: \(nombreMiTienda)"
        webSite.text = "Web Site: \(MiwebSite)"
        botonMapa.backgroundColor = UIColor.clear
        botonMapa.layer.cornerRadius = 5.0
        botonMapa.layer.borderWidth = 0.8
        botonMapa.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    @IBAction func verMapaButton(_ sender: Any) {
        performSegue(withIdentifier: "ubicacionSegue", sender: self)

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ubicacionViewController = segue.destination as! UbicacionViewController
        ubicacionViewController.puntoLatitud = puntoLatitud
        ubicacionViewController.puntoLongitud = puntoLongitud
        ubicacionViewController.latitudTienda = latitudTienda
        ubicacionViewController.longitudTienda = longitudTienda
        ubicacionViewController.nombreTienda = nombreMiTienda
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
