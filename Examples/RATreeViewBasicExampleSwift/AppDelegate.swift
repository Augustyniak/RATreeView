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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: TreeViewController())
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navigationController;
        window?.makeKeyAndVisible()
        return true
    }

}

