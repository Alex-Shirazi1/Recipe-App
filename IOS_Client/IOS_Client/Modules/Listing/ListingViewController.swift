//
//  ListingViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/21/23.
//

import Foundation
import UIKit

protocol ListingViewControllerProtocol: AnyObject {
    
}

class ListingViewController: UIViewController, ListingViewControllerProtocol {
    let eventHandler: ListingEventHandlerProtocol
    let post: Post
    
    init(eventHandler: ListingEventHandlerProtocol, post: Post) {
        self.eventHandler = eventHandler
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOLSSFND")
        print(post)
    }
    
    

    
}
