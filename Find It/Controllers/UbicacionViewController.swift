//
//  UbicacionViewController.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 15/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import UIKit

class UbicacionViewController: UIViewController {

    @IBOutlet weak var labelDestino: UILabel!
    @IBOutlet weak var labelOrigen: UILabel!
    @IBOutlet weak var iconoDestino: UIImageView!
    @IBOutlet weak var iconoOrigen: UIImageView!
    
    var miCadenaOrigen = String()
    var miCadenaDestino = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelOrigen.text = miCadenaOrigen
        labelDestino.text = miCadenaDestino
        
        print("MI CADENA ORIGEN ES: \(miCadenaOrigen)")
        print("MI CADENA DESTINO ES: \(miCadenaDestino)")
        // Do any additional setup after loading the view.
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
