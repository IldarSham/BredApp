//
//  AppDelegate.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 07.10.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appContainer = AppDependencyContainer()
    var appCoordinator: AppCoordinator?
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()

        window = UIWindow()
        window?.rootViewController = navigationController
        
        appCoordinator = AppCoordinator(router: NavigationRouter(navigationController: navigationController),
                                        startCoordinatorFactory: appContainer)
        appCoordinator?.start()
        
        window?.makeKeyAndVisible()
        
        return true
    }
}
