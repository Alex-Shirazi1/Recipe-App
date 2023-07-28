//
//  ProfileViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit


protocol ProfileViewControllerProtocol: AnyObject {
    
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    let eventHandler: ProfileEventHandlerProtocol
    
    init(eventHandler: ProfileEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

