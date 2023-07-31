//
//  RegisterViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/30/23.
//

import Foundation
import UIKit


protocol RegisterViewControllerProtocol: AnyObject {
    
}

class RegisterViewController: UIViewController, RegisterViewControllerProtocol {
    let eventHandler: RegisterEventHandlerProtocol
    
    init(eventHandler: RegisterEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

