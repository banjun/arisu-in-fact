//
//  AppDelegate.swift
//  ArisuInFact
//
//  Created by BAN Jun on 5/4/16.
//  Copyright © 2016 banjun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let w = UIWindow(frame: UIScreen.mainScreen().bounds)
        window = w
        let vc = ViewController()
        let nc = UINavigationController(rootViewController: vc)
        w.rootViewController = nc
        w.makeKeyAndVisible()
        return true
    }


}

