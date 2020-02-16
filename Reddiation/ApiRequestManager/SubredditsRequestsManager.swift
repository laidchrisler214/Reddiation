//
//  RedditRequestsManager.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/13/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.

import Foundation

protocol SubredditsDelegate {
    func didGetSubreddits(_ redditRequestsManager: SubredditsRequestsManager, subreddits: [SubredditsModel])
    func didFailWithError(error: Error)
}

struct SubredditsRequestsManager {
    var subredditsDelegate: SubredditsDelegate?
    
    func performGetSubRedditsRequest(limit: Int) {
        //1. create url
        let urlString = K.subredditURL + K.jsonExtension + K.resultLimit + "\(limit)"
        if let url = URL(string: urlString) {
            
            //2. create url session
            let session = URLSession(configuration: .default)
            
            //3. give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.subredditsDelegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let subreddits = self.parseSubRedditsJSON(safeData) {
                        self.subredditsDelegate?.didGetSubreddits(self, subreddits: subreddits)
                    }
                }
            }
            
            //4. start the task
            task.resume()
            
        }//end of if let url
    }//end of performRequest
    
    func parseSubRedditsJSON(_ subredditsRawData: Data) -> [SubredditsModel]? {
        let decoder = JSONDecoder()
        do {
            var subReddits = [SubredditsModel]()
            let decodedData = try decoder.decode(SubredditsData.self, from: subredditsRawData)
            let data = decodedData.data
            let children = data.children
            for item in children {
                let childrenData = item.data
                let title = childrenData.title
                let icon_img = childrenData.icon_img
                let display_name_prefixed = childrenData.display_name_prefixed
                let name = childrenData.name
                let subReddit = SubredditsModel(title: title, icon_img: icon_img, display_name_prefixed: display_name_prefixed, name: name)
                subReddits.append(subReddit)
            }
            return subReddits
        } catch {
            subredditsDelegate?.didFailWithError(error: error)
            return nil
        }
    }//end of parseSubRedditsJSON
    
}//end of struct RedditRequestsManager
