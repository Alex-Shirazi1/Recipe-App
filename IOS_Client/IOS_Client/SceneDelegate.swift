//
//  SceneDelegate.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 6/29/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = self.tabbar(controllers: [])
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window

        DispatchQueue.global(qos: .background).async {
            self.prepareViewControllers { controllers in
                DispatchQueue.main.async {
                    tabBarController.viewControllers = controllers
                }
            }
        }
    }
    
    private func prepareViewControllers(completion: @escaping ([UIViewController]) -> Void) {
        DispatchQueue.main.async {
            let controllers = self.createViewControllers()
            completion(controllers)
        }
    }
    
    private func createViewControllers() -> [UIViewController] {
        
        // HomeModule Logic
        
        let homeNavigationViewController = UINavigationController()
        let homeViewController = HomeRouter.createModule(navigationController: homeNavigationViewController)
        homeNavigationViewController.viewControllers = [homeViewController]
        homeNavigationViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        // Search Module Logic
        
        let searchNavigationController = UINavigationController()
        let searchViewController = SearchRouter.createModule(navigationController: searchNavigationController)
        searchNavigationController.viewControllers = [searchViewController]
        searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        // CreatePost Module Logic
        
        let createPostNavigationController = UINavigationController()
        let createPostViewController = CreatePostRouter.createModule(navigationController: createPostNavigationController)
        createPostNavigationController.viewControllers = [createPostViewController]
        createPostNavigationController.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus"), tag: 2)

        // Profile Module Logic
        
        let profileNavigationController = UINavigationController()
        let profileViewController = ProfileRouter.createModule(navigationController: profileNavigationController)
        profileNavigationController.viewControllers = [profileViewController]
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)

        // Settings Module Logic
        
        let settingsNavigationController = UINavigationController()
        let settingsViewController = SettingsRouter.createModule(navigationController: settingsNavigationController)
        settingsNavigationController.viewControllers = [settingsViewController]
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        return [homeNavigationViewController, searchNavigationController, createPostNavigationController, profileNavigationController, settingsNavigationController]
    }

    private func tabbar(controllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = .black
        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
