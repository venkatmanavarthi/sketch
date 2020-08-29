//
//  LoginViewController.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController : UIViewController{
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(loginUpButtonClicked), for: .touchUpInside)
        button.setTitle("Login", for: .normal)
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
        self.title = "Login"
        
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
        self.view.addSubview(loginButton)
        loginButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 25),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    @objc func loginUpButtonClicked(){
        if let email = email.text,let password = password.text{
            if email != "",password != ""{
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    if let e = error{
                        self?.alert(with: e.localizedDescription)
                        return
                    }else{
                        let Yours = UINavigationController(rootViewController: PrimaryDrawingViewController())
                              let sharedDrawingVc = UINavigationController(rootViewController: SharingViewController())
                              let mainVc = UITabBarController()
                              mainVc.viewControllers = [Yours,sharedDrawingVc]
                              mainVc.selectedViewController = Yours
                        Yours.tabBarItem = self!.setTabBarItem(with: "brush")
                              Yours.title = "Your Drawing"
                        sharedDrawingVc.tabBarItem = self!.setTabBarItem(with: "folder")
                              sharedDrawingVc.title = "Sharing"
                        self?.navigationController?.pushViewController(mainVc, animated: true)
                    }
                }
            }else{
                alert(with: "Please Enter email and password")
            }
        }else{
            alert(with: "Please Enter email and password")
        }
    }
    func setTabBarItem(with icon : String) -> UITabBarItem{
            let item = UITabBarItem()
            item.image = UIImage(named: icon)
    //        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.title = nil
            return item
        }
}
