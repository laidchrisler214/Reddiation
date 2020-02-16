//
//  PostsTableViewCell.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/15/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import UIKit

class PostingsTableViewCell: UITableViewCell {
    @IBOutlet weak var postIcon: UIImageView!
    @IBOutlet weak var postLabel: UITextView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postIcon.image = nil
    }
    
    func configureCell(postingsModel: PostingsModel) {
        postLabel.text = postingsModel.title
        if let imageStringUrl = postingsModel.thumbnail {
            if !imageStringUrl.isEmpty {
                postIcon.setImageFrom(imageStringUrl) { (imageDidSet, error) in
                    if imageDidSet == false {
                        print(error!)
                        DispatchQueue.main.async {
                            self.imageWidthConstraint.constant = 0
                            self.postIcon.layoutIfNeeded()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.imageWidthConstraint.constant = 0
                    self.postIcon.layoutIfNeeded()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.imageWidthConstraint.constant = 0
                self.postIcon.layoutIfNeeded()
            }
        }
    }
}
