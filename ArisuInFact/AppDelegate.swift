//
//  AppDelegate.swift
//  ArisuInFact
//
//  Created by BAN Jun on 5/4/16.
//  Copyright © 2016 banjun. All rights reserved.
//

import UIKit
import SwiftyDropbox


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
        
        Dropbox.setupWithAppKey("b6raybvhh1snp6f")
        
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if let authResult = Dropbox.handleRedirectURL(url) {
            switch authResult {
            case .Success(let token):
                print("Success! User is logged into Dropbox with token: \(token)")
            case .Error(let error, let description):
                print("Error \(error): \(description)")
            }
        }
        return true
    }
}

