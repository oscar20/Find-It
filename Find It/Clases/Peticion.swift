//
//  Peticion.swift
//  Find It
//
//  Created by Oscar Almazan Lora on 01/07/18.
//  Copyright © 2018 d182_oscar_a. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Peticion{
    
    final let apiKey = "4ee7cdf8c6a05e6f91f8077f3bd003ba"
    var productsName : [String] = []
    
    func getStores(latitud: Double, longitud: Double, parametroProducto : UITextField) -> String{
        var resultadoPeticion : String = ""
        print("Running getStores...")
        print("Tu coordenada de latitud es: \(latitud) y longitud: \(longitud)")
        
        guard let textTextField = parametroProducto.text else {return "No se ingreso texto"}//Valido que mi TextField contenga una cadena.
        let textTextField_trimmed  = textTextField.trimmingCharacters(in: .whitespaces) //Recorto la cadena.
        let formattingText = textTextField_trimmed.replacingOccurrences(of: " ", with: "+") //Reemplazando espacios en blanco.
        if formattingText.isEmpty{
            print("Empty string...")
        }else{
            print("The parameter is:\(formattingText).")
            let urlString = "https://api.goodzer.com/products/v0.1/search_stores/?query=\(formattingText)&lat=\(latitud)&lng=\(longitud)&radius=5&priceRange=30:120&apiKey=\(apiKey)" //Armo mi URL para la peticion.
            let url = URL(string: urlString) //Ejecuto mi peticion
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                print("Getting stores...")
                guard let data = data else {return}
                //Parseo...
                do{
                    let productStore = try JSONDecoder().decode(PeticionProducto.self, from: data)
                    if productStore.stores_found == nil || productStore.stores_found! == 0 {
                        print("No se encontro ninguna tienda con el producto")
                    }else{
                        productStore.stores?.forEach({ (store) in
                            print("NAME:\(store.name!)\n")
                            self.productsName.append(store.name!)
                            store.products?.forEach({ (producto) in
                                print("URL:\(producto.url!)")
                            })
                        })
                        resultadoPeticion = String(describing: productStore.status)
                        print("Res pet..:\(resultadoPeticion)")
                        print("Status: \(String(describing: productStore.status))")
                        print("WebSite de primer tienda: \(String(describing: productStore.stores?.first?.website))")
                        print("Stores_found: \(String(describing: productStore.stores_found))")
                        print("Time: \(String(describing: productStore.time))")
                        
                    }
                    
                }catch let error{
                    print("Error: ", error)
                }
                print("Res pet3..:\(resultadoPeticion)")
            }.resume()
            
            
            print("Res pet2..:\(resultadoPeticion)")
        }
        print("La salida de la funcion fue: \(resultadoPeticion)")
        print("ELEMENTOS ARRAY: \(productsName.count)")
        return resultadoPeticion
    }
    
    func getStoresAlamo(latitud: Double, longitud: Double, parametroProducto : UITextField) {
        var productsName2 : [String] = []
        guard let textTextField = parametroProducto.text else {return}//Valido que mi TextField contenga una cadena.
        let textTextField_trimmed  = textTextField.trimmingCharacters(in: .whitespaces) //Recorto la cadena.
        let formattingText = textTextField_trimmed.replacingOccurrences(of: " ", with: "+") //Reemplazando espacios en blanco.
        if formattingText.isEmpty{
            print("Empty string...")
        }else{
            let urlString = "https://api.goodzer.com/products/v0.1/search_stores/?query=\(formattingText)&lat=\(latitud)&lng=\(longitud)&radius=5&priceRange=30:120&apiKey=\(apiKey)" //Armo mi URL para la peticion.
            let url = URL(string: urlString) //Ejecuto mi peticion
                Alamofire.request(url!).responseData{ (dataResponse) in
                    if let err = dataResponse.error{
                        print("Hubo un error", err)
                        return
                    }
                    guard let data = dataResponse.data else {return }
                    //let testString = String(data: data, encoding: .utf8)
                    //print(testString ?? "")
                    do{
                        let productStore = try JSONDecoder().decode(PeticionProducto.self, from: data)
                        
                        print("Results", productStore.status!)
                        
                        productStore.stores?.forEach({ (store) in
                            print("NAME:\(store.name!)\n")
                            productsName2.append("1")
                            store.products?.forEach({ (producto) in
                                print("URL:\(producto.url!)")
                            })
                        })
                        self.productsName = productsName2
                    print("###### \(self.productsName.count)")
                    }catch let decodeError{
                        print("Error: ", decodeError)
                    }
                }
        }
        print("ELEMENTOS ARRAY: \(productsName.count)")

    }
    
    
}
