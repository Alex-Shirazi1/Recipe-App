import Foundation
import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var eventHandler: ProfileEventHandlerProtocol? { get set }
    
    func showLoginView(_ viewController: UIViewController)
    
    func showRegisterView(_ viewController: UIViewController)
    
    func updateUI()
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileViewControllerProtocol {
    
    var eventHandler: ProfileEventHandlerProtocol?
    
    let tableViewCellFactory: TableViewCellFactoryType
    
    let profileOptions: [TableOption] = [
        TableOption(text: "Sign In", image: "person.fill"),
        TableOption(text: "Don't have an account?", image: "person.badge.plus.fill"),
        TableOption(text: "Logout", image: "power")
    ]
    
    let profileContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(eventHandler: ProfileEventHandlerProtocol, tableViewCellFactory: TableViewCellFactoryType ) {
        self.eventHandler = eventHandler
        self.tableViewCellFactory = tableViewCellFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        profileContainerView.addSubview(usernameLabel)
        profileContainerView.addSubview(profileImage)
        
        view.backgroundColor = .white
        view.addSubview(profileContainerView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            usernameLabel.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor),
            
            profileImage.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: 20),
            profileImage.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileContainerView.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    func updateUI() {
        if TokenFactory.appToken.isLoggedIn() {
            usernameLabel.isHidden = false
            usernameLabel.text = TokenFactory.appToken.getUsername()
        } else {
            usernameLabel.text = ""
            usernameLabel.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TokenFactory.appToken.isLoggedIn() ? 1 : profileOptions.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let roughCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tableOption = profileOptions[TokenFactory.appToken.isLoggedIn() ? 2 : indexPath.row]
        let cell = tableViewCellFactory.styleCell(cell: roughCell, tableOption: tableOption)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if TokenFactory.appToken.isLoggedIn() {
            // If logged in we want to hide the other table fields sign in and register
            TokenFactory.appToken.destroyToken()
            updateUI()
            let banner = BannerViewController(message: "Logout Successful")
            banner.presentBanner(from: self, withDelay: true)
            
        } else {
            // If logged out, we want to hide logout
            switch indexPath.row {
            case 0:
                eventHandler?.signInButtonTapped(profileViewController: self)
            case 1:
                eventHandler?.registerButtonTapped()
            default:
                break
            }
        }
    }
    
    
    func showLoginView(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showRegisterView(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
