//
//  AppDelegate.swift
//  RATreeViewBasicExampleSwift
//
//  Created by Rafal Augustyniak on 21/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: TreeViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController;
        window?.makeKeyAndVisible()
        return true
    }

}

