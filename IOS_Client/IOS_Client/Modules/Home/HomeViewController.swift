//
//  HomeViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/14/23.
//

import Foundation
import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func updatePosts(_ posts: [Post])
}

class HomeViewController: UIViewController, HomeViewControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var eventHandler: HomeEventHandlerProtocol
    
    private lazy var posts: [Post] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipePostCell.self, forCellWithReuseIdentifier: "PostCell")
        return collectionView
    }()

    
    init(eventHandler: HomeEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        self.eventHandler.fetchPosts()
    }
    
    func updatePosts(_ posts: [Post]) {
        print("Posts received in HomeViewController: \(posts)")
        self.posts = posts
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        eventHandler.didSelectPost(post: post)
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? RecipePostCell else {
            fatalError("The dequeued cell is not an instance of RecipePostCell")
        }

        let post = posts[indexPath.item]
        cell.title = post.title
        cell.username = post.username
        guard let imageID = post.imageFileId else {
            return cell
        }
        self.eventHandler.fetchImage(with: imageID) { image in
            DispatchQueue.main.async {
                cell.image = image
            }
        }
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }

}
