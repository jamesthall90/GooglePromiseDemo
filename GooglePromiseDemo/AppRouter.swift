//
//  AppRouter.swift
//  GooglePromiseDemo
//
//  Created by James Hall on 9/13/18.
//  Copyright © 2018 JTH. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

enum RoutingDestination: String {
    case randomSwansonView = "SingleSwansonViewController"
    case mainMenu = "MainMenuViewController"
}

final class AppRouter {
    
    let navigationController: UINavigationController
    
    init(window: UIWindow) {
        
        navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }
    
    fileprivate func pushViewController(identifier: String, animated: Bool) {
        
        let viewController = instantiateViewController(identifier: identifier)
        
        let newViewControllerType = type(of: viewController)
        
        if let currentVc = navigationController.topViewController {
            
            let currentViewControllerType = type(of: currentVc)
            
            if currentViewControllerType == newViewControllerType {
                return
            }
        }
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    private func instantiateViewController(identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: - StoreSubscriber
extension AppRouter: StoreSubscriber {
    func newState(state: RoutingState) {
        let shouldAnimate = navigationController.topViewController != nil
        pushViewController(identifier: state.navigationState.rawValue, animated: shouldAnimate)
    }
}
