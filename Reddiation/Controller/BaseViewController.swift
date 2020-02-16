//
//  BaseViewController.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/16/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var indicator = UIActivityIndicatorView()
    var limit = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func startActivityIndicator() {
        indicator.startAnimating()
        indicator.backgroundColor = .white
    }
    
    func stopActivityIndicator() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
}
