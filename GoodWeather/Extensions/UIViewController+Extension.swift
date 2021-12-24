//
//  addCity.swift
//  GoodWeather
//
//  Created by Игорь Павличенков on 22.12.2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertAddCity(name: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let textFieldtext = alertController.textFields?.first
            guard let text = textFieldtext?.text else { return }
            completionHandler(text)
        }
        
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .default) { (_) in }
        
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
