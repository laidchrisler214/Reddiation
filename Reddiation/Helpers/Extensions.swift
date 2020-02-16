//
//  Extensions.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/14/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }

    func setImageFrom(_ urlString: String, completion: @escaping ( Bool?, Error? )->Void ) {
        guard let url = URL(string: urlString) else { return }

        let session = URLSession(configuration: .default)
        let activityIndicator = self.activityIndicator

        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }

        let downloadImageTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(false, error)
            } else {
                if let imageData = data {
                    DispatchQueue.main.async {[weak self] in
                        var image = UIImage(data: imageData)
                        self?.image = nil
                        self?.image = image
                        image = nil
                        completion(true, nil)
                    }
                }
            }
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            session.finishTasksAndInvalidate()
        }
        downloadImageTask.resume()
    }
}//end of extension UIImageView
