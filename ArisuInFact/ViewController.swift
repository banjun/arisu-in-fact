//
//  ViewController.swift
//  ArisuInFact
//
//  Created by BAN Jun on 5/4/16.
//  Copyright © 2016 banjun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
    }
}

