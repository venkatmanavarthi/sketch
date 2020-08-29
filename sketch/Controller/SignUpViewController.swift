//
//  SignUpViewController.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController : UIViewController{
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        button.setTitle("SignUp", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let email : UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let password : UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "SignUp"
        
        [email,password].forEach { (textField) in
            self.view.addSubview(textField)
            textField.layer.cornerRadius = 2
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.layer.borderWidth = 1
            textField.setLeftPaddingPoints(5)
            textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
            if textField == self.email{
                textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
            }else{
                textField.topAnchor.constraint(equalTo: self.email.bottomAnchor, constant: 30).isActive = true
            }
        }
        self.view.addSubview(signUpButton)
        signUpButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 25),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            signUpButton.widthAnchor.constraint(equalToConstant: 250),
            signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    @objc func signUpButtonClicked(){
        if let email = email.text,let password = password.text{
            if email != "",password != ""{
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        self.alert(with: e.localizedDescription)
                        return
                    }else{
                        let slatVC = SlateViewController()
                        self.navigationController?.pushViewController(slatVC, animated: true)
                    }
                }
            }else{
                alert(with: "Please Enter email and password")
            }
        }else{
            alert(with: "Please Enter email and password")
        }
    }
}
