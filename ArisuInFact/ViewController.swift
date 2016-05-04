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
    private let imageView: UIImageView = UIImageView(frame: .zero) ※ { v in
        v.contentMode = .ScaleAspectFit
    }
    private lazy var yesButton: UIButton = UIButton(type: .System) ※ { b in
        b.setTitle("ありす", forState: .Normal)
        b.addTarget(self, action: #selector(yes), forControlEvents: .TouchUpInside)
    }
    private lazy var noButton: UIButton = UIButton(type: .System) ※ { b in
        b.setTitle("ちがう", forState: .Normal)
        b.addTarget(self, action: #selector(no), forControlEvents: .TouchUpInside)
    }
    
    let sourceFolderPath = "/codefirst/Products/LoveLiver/face/_undetermined" // show images and user determine whether yes or no
    let yesDestinationFolderPath = "/codefirst/Products/LoveLiver/face/arisu" // where move yes images
    let noDestinationFolderPath = "/codefirst/Products/LoveLiver/face/non-arisu" // where move no images
    var undeterminedFaces = [(name: String, image: UIImage)]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Arisu in fact"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        
        let autolayout = view.northLayoutFormat(["p": 8], [
            "image": imageView,
            "yes": yesButton,
            "no": noButton,
            "spacerT": MinView(),
            "spacerB": MinView(),
            ])
        autolayout("H:|[image]|")
        autolayout("H:|-p-[no]-p-[yes(==no)]-p-|")
        autolayout("V:|-p-[spacerT][image]")
        autolayout("V:[image][yes][spacerB]")
        autolayout("V:[image][no][spacerB]")
        autolayout("V:[spacerB(==spacerT)]-p-|")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .Plain, target: self, action: #selector(signin))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let client = Dropbox.authorizedClient {
            client.files.listFolder(path: sourceFolderPath).response { (result, error) in
                NSLog("%@", "result = \(result), error = \(error)")
                
                client.files.createFolder(path: self.yesDestinationFolderPath)
                client.files.createFolder(path: self.noDestinationFolderPath)
                
                for entry in result?.entries ?? [] {
                    client.files.download(path: entry.pathLower, destination: { (url, response) -> NSURL in
                        let u = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(entry.name)
                        let _ = try? NSFileManager.defaultManager().removeItemAtURL(u)
                        return u
                    }).response({ entryAndURL, error in
                        guard let file = entryAndURL?.1.path,
                            let image = UIImage(contentsOfFile: file) else { return }
                        
                        self.undeterminedFaces.append((name: entry.name, image: image))
                        self.reloadImageView()
                    })
                }
            }
        }
    }
    
    private func reloadImageView() {
        imageView.image = undeterminedFaces.first?.image
    }
    
    @objc private func signin() {
        if let _ = Dropbox.authorizedClient {
            Dropbox.unlinkClient() // 既にログイン済みだとクラッシュするのでログアウトする
        }
        Dropbox.authorizeFromController(self)
    }
    
    @objc private func yes() {
        determineToDestination(yesDestinationFolderPath)
    }
    
    @objc private func no() {
        determineToDestination(noDestinationFolderPath, copy: true)
    }
    
    private func determineToDestination(destinationPath: String, copy: Bool = false) {
        guard let face = undeterminedFaces.first,
            let client = Dropbox.authorizedClient else { return }
        
        let from = sourceFolderPath + "/" + face.name
        let to = destinationPath + "/"  + face.name
        if copy {
            client.files.copy(fromPath: from, toPath: to).response { (metadata, error) in
                NSLog("%@", "files.copy metadata: \(metadata) error: \(error)")
            }
        } else {
            client.files.move(fromPath: from, toPath: to).response { (metadata, error) in
                NSLog("%@", "files.move metadata: \(metadata) error: \(error)")
            }
        }
        
        undeterminedFaces.removeFirst()
        reloadImageView()
    }
}


class MinView: UIView {
    override func intrinsicContentSize() -> CGSize {
        return CGSizeZero
    }
}
