//
//  ViewController.swift
//  ArisuInFact
//
//  Created by BAN Jun on 5/4/16.
//  Copyright © 2016 banjun. All rights reserved.
//

import UIKit
import SwiftyDropbox
import NorthLayout
import Ikemen


class ViewController: UIViewController {
    private let imageView = UIImageView(frame: .zero) ※ {$0.contentMode = .ScaleAspectFit}
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Arisu in fact"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .whiteColor()
        
        let autolayout = view.northLayoutFormat(["p": 8], [
            "image": imageView,
            ])
        autolayout("H:|[image]|")
        autolayout("V:|[image]|")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .Plain, target: self, action: #selector(signin))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let client = Dropbox.authorizedClient {
            client.files.listFolder(path: "/codefirst/Products/LoveLiver/face/tulip2").response { (result, error) in
                NSLog("%@", "result = \(result), error = \(error)")
                for entry in result?.entries ?? [] {
                    client.files.download(path: entry.pathLower, destination: { (url, response) -> NSURL in
                        let u = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(entry.name)
                        let _ = try? NSFileManager.defaultManager().removeItemAtURL(u)
                        return u
                    }).response({ entryAndURL, error in
                        guard let file = entryAndURL?.1.path else { return }
                        self.imageView.image = UIImage(contentsOfFile: file)
                    })
                }
            }
        }
    }
    
    @objc private func signin() {
        if let _ = Dropbox.authorizedClient {
            Dropbox.unlinkClient() // 既にログイン済みだとクラッシュするのでログアウトする
        }
        Dropbox.authorizeFromController(self)
    }
}

