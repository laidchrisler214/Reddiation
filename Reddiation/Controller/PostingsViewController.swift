//
//  PostingsViewController.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/15/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import UIKit

class PostingsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var subreddit: SubredditsModel?
    var postingsRequestsManager = PostingsRequestsManager()
    var postingsArray = [PostingsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postingsRequestsManager.postingsDelegate = self
        startActivityIndicator()
        postingsRequestsManager.performGetPostingsRequest(subreddit!.display_name_prefixed, limit: limit)
        navigationItem.title = subreddit?.display_name_prefixed
    }
}

//MARK:- Table Datasource
extension PostingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.postingsCellIdentifier, for: indexPath) as! PostingsTableViewCell
        cell.configureCell(postingsModel: postingsArray[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if limit < 100 {
                limit += 25
                postingsRequestsManager.performGetPostingsRequest(subreddit!.display_name_prefixed, limit: limit)
            }
        }
    }
}

//MARK:- Table Delegate
extension PostingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueToContent, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ContentViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.postingsModel = postingsArray[indexPath.row]
        }
    }
}

//MARK:- Postings Delegate
extension PostingsViewController: PostingsDelegate {
    func didGetPostings(_ redditRequestsManager: PostingsRequestsManager, postings: [PostingsModel]) {
        DispatchQueue.main.async {
            self.postingsArray.removeAll()
            self.postingsArray = postings
            self.stopActivityIndicator()
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}//end of PostingsViewController
