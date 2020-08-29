//
//  Welcome.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
class WelcomeViewController : UIViewController{
    let sketchLabel : UILabel = {
        let label = UILabel()
        label.text = "Sketch"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
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
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Welcome"
        
        [sketchLabel,signUpButton,loginButton].forEach(self.view.addSubview)
        [loginButton,signUpButton].forEach { (button) in
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.widthAnchor.constraint(equalToConstant: 250).isActive = true
            button.layer.cornerRadius = 10
        }
        
        NSLayoutConstraint.activate([
            sketchLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            sketchLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: self.signUpButton.topAnchor, constant: -20),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    @objc func signUpButtonClicked(){
        let signupVC = SignUpViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    @objc func loginButtonClicked(){
        let loginVc = LoginViewController()
        navigationController?.pushViewController(loginVc, animated: true)
    }
    
}
