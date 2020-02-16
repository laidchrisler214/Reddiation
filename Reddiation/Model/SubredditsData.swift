//
//  SubredditsData.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/14/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import Foundation

struct SubredditsData: Codable {
    let data: SubredditData
}

struct SubredditData: Codable {
    let children: [Children]
}

struct Children: Codable {
    let data: ChildrenData
}

struct ChildrenData: Codable {
    let title: String
    let icon_img: String?
    let display_name_prefixed: String
    let name: String
}
