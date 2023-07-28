//
//  CreatePostViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/28/23.
//

import Foundation
import UIKit


protocol CreatePostViewControllerProtocol: AnyObject {
    
}

class CreatePostViewController: UIViewController, CreatePostViewControllerProtocol {
    let eventHandler: CreatePostEventHandlerProtocol
    
    init(eventHandler: CreatePostEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

