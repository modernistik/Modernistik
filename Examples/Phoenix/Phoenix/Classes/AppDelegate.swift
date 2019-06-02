//
//  AppDelegate.swift
//  Phoenix
//
//  Created by Anthony Persaud on 6/2/19.
//  Copyright © 2019 Modernistik. All rights reserved.
//

import UIKit
import Modernistik

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("[AppDelegate] applicationdidFinishLaunchingWithOptions")
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("[AppDelegate] applicationDidEnterBackground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("[AppDelegate] applicationDidBecomeActive")
        Phoenix.start()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("[AppDelegate] applicationWillTerminate")
    }


}

