//
//  PostingsData.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/15/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import Foundation

struct PostingsData: Codable {
    let data: PostingData
}

struct PostingData: Codable {
    let children: [PostingChildren]
}

struct PostingChildren: Codable {
    let data: PostingChildrenData
}

struct PostingChildrenData: Codable {
    let title: String
    let thumbnail: String?
    let permalink: String
}
