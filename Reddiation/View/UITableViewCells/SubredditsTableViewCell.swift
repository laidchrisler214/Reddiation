//
//  SubredditsTableViewCell.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/13/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import UIKit

class SubredditsTableViewCell: UITableViewCell {
    @IBOutlet weak var subredditIcon: UIImageView!
    @IBOutlet weak var subredditLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subredditIcon.image = nil
    }
    
    func configureCell(subredditModel: SubredditsModel) {
        subredditLabel.text = subredditModel.display_name_prefixed
        if let imageStringUrl = subredditModel.icon_img {
            if !imageStringUrl.isEmpty {
                subredditIcon.setImageFrom(imageStringUrl) { (imageDidSet, error) in
                    if imageDidSet == false {
                        print(error!)
                        self.subredditIcon.image = UIImage(named: "placeholder")
                    }
                }
            } else {
                subredditIcon.image = UIImage(named: "placeholder")
            }
        } else {
            subredditIcon.image = UIImage(named: "placeholder")
        }
    }
}
