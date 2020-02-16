//
//  PostingsRequestsManager.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/15/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import Foundation

protocol PostingsDelegate {
    func didGetPostings(_ redditRequestsManager: PostingsRequestsManager, postings: [PostingsModel])
    func didFailWithError(error: Error)
}

struct PostingsRequestsManager {
    var postingsDelegate: PostingsDelegate?
    
    func performGetPostingsRequest(_ display_name_prefixed: String, limit: Int) {
        //1. create url
        let urlString = K.postingsURL + display_name_prefixed + "/" + K.jsonExtension + K.resultLimit + "\(limit)"
        if let url = URL(string: urlString) {
            
            //2. create url session
            let session = URLSession(configuration: .default)
            
            //3. give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.postingsDelegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let postings = self.parsePostingsJSON(safeData) {
                        self.postingsDelegate?.didGetPostings(self, postings: postings)
                    }
                }
            }
            
            //4. start the task
            task.resume()
            
        }//end of if let url
    }//end of performRequest
    
    func parsePostingsJSON(_ postingsRawData: Data) -> [PostingsModel]? {
        let decoder = JSONDecoder()
        do {
            var postings = [PostingsModel]()
            let decodedData = try decoder.decode(PostingsData.self, from: postingsRawData)
            let data = decodedData.data
            let children = data.children
            for item in children {
                let childrenData = item.data
                let title = childrenData.title
                let thumbnail = childrenData.thumbnail
                let permalink = childrenData.permalink
                let posting = PostingsModel(title: title, thumbnail: thumbnail, permalink: permalink)
                postings.append(posting)
            }
            return postings
        } catch {
            postingsDelegate?.didFailWithError(error: error)
            return nil
        }
    }//end of parsePostingsJSON
    
}//end of struct PostingsRequestsManager
