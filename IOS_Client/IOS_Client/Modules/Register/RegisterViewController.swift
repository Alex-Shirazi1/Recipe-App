//
//  RegisterViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation
import UIKit

protocol RegisterViewControllerProtocol: AnyObject {
    func navigateToLogin()
    func showErrorAlert(error: Error)
}

class RegisterViewController: UIViewController, RegisterViewControllerProtocol {
    
    let eventHandler: RegisterEventHandlerProtocol
    
    private let usernameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let RegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(eventHandler: RegisterEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    private func setup() {
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(RegisterButton)
        
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            
            RegisterButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func didTapRegisterButton() {
        guard let username = usernameField.text, let email = emailField.text, let password = passwordField.text else {
            print("Fields are empty.")
            return
        }
        
        eventHandler.registerUser(username: username, email: email, password: password)
    }
    
    func showErrorAlert(error: Error) {
        let message = (error as? ValidationError)?.localizedDescription ?? error.localizedDescription
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }


    
    func navigateToLogin() {
        eventHandler.navigateToLogin()
    }
}
