//
//  RecipePostCell.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/17/23.
//

import Foundation
import UIKit

class RecipePostCell: UICollectionViewCell {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var username: String? {
        didSet {
            usernameLabel.text = "by: \(username ?? "Unknown User")"
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(usernameLabel)
        
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
        
        // add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            usernameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
