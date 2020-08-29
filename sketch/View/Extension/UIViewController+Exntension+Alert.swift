//
//  UIViewController+Exntension+Alert.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
extension UIViewController{
    func alert(with message: String){
        let alert = UIAlertController(title: "Sketch", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert,animated: true)
    }
}
