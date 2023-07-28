//
//  SettingsEventHandler.swift
//  IOS_Client
//
//  Created by Alex Shirazi on 7/26/23.
//

import Foundation

protocol SettingsEventHandlerProtocol: AnyObject {
    var viewController: SettingsViewControllerProtocol? { get set }
    
    func navigateToFeedBack()
    
    func navigateToAbout()
}

class SettingsEventHandler: SettingsEventHandlerProtocol {
    weak var viewController: SettingsViewControllerProtocol?
    let interactor: SettingsInteractorProtocol
    let router: SettingsRouterProtocol
    
    init(interactor: SettingsInteractorProtocol, router: SettingsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func navigateToFeedBack() {
        router.navigateToFeedback()
    }
    
    func navigateToAbout() {
        router.navigateToAbout()
    }
}
