//
//  SearchViewController.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/25/23.
//

import Foundation
import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func updateWithSearchResults(_ posts: [Post])
}

class SearchViewController: UIViewController, SearchViewControllerProtocol, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    let eventHandler: SearchEventHandlerProtocol
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    var posts: [Post] = []

    init(eventHandler: SearchEventHandlerProtocol) {
        self.eventHandler = eventHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar = UISearchBar()
        searchBar.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 200)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipePostCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.backgroundColor = .white

        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        eventHandler.searchPosts(query: query)
    }

    func updateWithSearchResults(_ posts: [Post]) {
        self.posts = posts
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        eventHandler.didSelectPost(post: post)
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! RecipePostCell
        let post = posts[indexPath.row]
        cell.title = post.title
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
}
