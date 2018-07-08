//
//  resultadosViewController.swift
//  
//
//  Created by Oscar Almazan Lora on 07/07/18.
//

import UIKit

class resultadosViewController: UIViewController {
    
    let labelSecondController : UILabel = {
       let lb = UILabel()
        lb.text = ""
        lb.backgroundColor = UIColor.yellow
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(labelSecondController)
        
        labelSecondController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelSecondController.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    }

    

}
