//
//  SettingsRouter.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation
import UIKit

protocol SettingsRouterProtocol: AnyObject {
    static func createModule(navigationController: UINavigationController) -> UIViewController
    
    func navigateToFeedback()
    
    func navigateToAbout()
    
    func navigateToTerms()
}

class SettingsRouter: SettingsRouterProtocol {
    weak var navigationController: UINavigationController?
    
    static func createModule(navigationController: UINavigationController) -> UIViewController {
        let interactor: SettingsInteractorProtocol = SettingsInteractor()
        let router: SettingsRouter = SettingsRouter()
        router.navigationController = navigationController
        let eventHandler: SettingsEventHandlerProtocol = SettingsEventHandler(interactor: interactor, router: router)
        let viewController = SettingsViewController(eventHandler: eventHandler, tableViewCellFactory: TableViewCellFactory())
        eventHandler.viewController = viewController
        return viewController
    }
    
    func navigateToFeedback() {
        let feedbackModule = FeedbackRouter.createModule()
        navigationController?.pushViewController(feedbackModule, animated: true)
    }
    func navigateToAbout() {
        let aboutViewController = AboutViewController()
        navigationController?.pushViewController(aboutViewController, animated: true)
    }
    func navigateToTerms() {
        let termsViewController = TermsViewController()
        navigationController?.pushViewController(termsViewController, animated: true)
    }
}
