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

class HomeViewController: UIViewController, HomeViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    var eventHandler: HomeEventHandlerProtocol
    
    private lazy var posts: [Post] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        return tableView
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
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        //legacyFetchPosts()
        self.eventHandler.fetchPosts()
    }
    func legacyfetchPosts() {
        guard let url = URL(string: MainConfig.serverAddress + "/posts") else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let decoder = JSONDecoder()

                if let posts = try? decoder.decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.posts = posts
                        self.tableView.reloadData()
                    }
                }
            }
        }

        task.resume()
    }
    
    func updatePosts(_ posts: [Post]) {
        print("Posts received in HomeViewController: \(posts)") // add this
        self.posts = posts
        tableView.reloadData()
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        
        return cell
    }
}
