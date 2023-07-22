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
    
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
        view.backgroundColor = .white
        print("LOL")
        print(post)
        setView()
    }
    
    private func setView() {
        titleLabel.textAlignment = .center
        titleLabel.text = post.title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        
        bodyLabel.textAlignment = .center
        bodyLabel.text = post.body
        bodyLabel.numberOfLines = 0
        
        if let imageID = post.imageFileId {
             eventHandler.fetchImage(with: imageID) { [weak self] image in
                 DispatchQueue.main.async {
                     self?.imageView.image = image
                 }
             }
         }
         
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, imageView, bodyLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
   
}
