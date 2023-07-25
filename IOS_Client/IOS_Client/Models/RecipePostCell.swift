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
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        backgroundColor = .white
        imageView.backgroundColor = .gray
        titleLabel.backgroundColor = .lightGray

        // add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        let imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 150)
        imageHeightConstraint.priority = UILayoutPriority(999)
        imageHeightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
