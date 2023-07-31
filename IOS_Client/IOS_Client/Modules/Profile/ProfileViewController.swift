import Foundation
import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var eventHandler: ProfileEventHandlerProtocol? { get set }
    func showLoginView(_ viewController: UIViewController)
    func showRegisterView(_ viewController: UIViewController)
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileViewControllerProtocol {
    
    var eventHandler: ProfileEventHandlerProtocol?
    
    let tableViewCellFactory: TableViewCellFactoryType
    
    let profileOptions: [TableOption] = [
        TableOption(text: "Sign In", image: "person.fill"),
        TableOption(text: "Don't have an account?", image: "person.badge.plus.fill")
    ]
    
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
        view.backgroundColor = .white
        view.addSubview(profileImage)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
             profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
             profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             profileImage.widthAnchor.constraint(equalToConstant: 150),
             profileImage.heightAnchor.constraint(equalToConstant: 150),
             
             tableView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows is based on profileOptions.count
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptions.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let roughCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tableOption = profileOptions[indexPath.row]
        let cell = tableViewCellFactory.styleCell(cell: roughCell, tableOption: tableOption)
        return cell
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            eventHandler?.signInButtonTapped()
        case 1:
            eventHandler?.registerButtonTapped()
        default:
            break
        }
    }
    
    func showLoginView(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showRegisterView(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
