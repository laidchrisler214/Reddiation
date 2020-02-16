//
//  SubRedditsViewController.swift
//  Reddiation
//
//  Created by Chrisler Laid on 2/13/20.
//  Copyright © 2020 Chrisler Laid. All rights reserved.
//

import UIKit

class SubRedditsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var redditRequestManager = SubredditsRequestsManager()
    var subRedditsArray = [SubredditsModel]()
    var filteredSubreddits = [SubredditsModel]()
    var resultSearchController = UISearchController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        redditRequestManager.subredditsDelegate = self
        startActivityIndicator()
        redditRequestManager.performGetSubRedditsRequest(limit: limit)
        initializeSearchController()
    }
    
    func initializeSearchController() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        tableView.reloadData()
    }
}//end of class

// MARK: - Table view data source
extension SubRedditsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredSubreddits.count
        } else {
            return subRedditsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.subredditCellIdentifier, for: indexPath) as! SubredditsTableViewCell
        if (resultSearchController.isActive) {
            cell.configureCell(subredditModel: filteredSubreddits[indexPath.row])
        } else {
            cell.configureCell(subredditModel: subRedditsArray[indexPath.row])
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if limit < 100 {
                limit += 25
                redditRequestManager.performGetSubRedditsRequest(limit: limit)
            }
        }
    }
}

// MARK: - Table view delegate
extension SubRedditsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueToPostings, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostingsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            if (resultSearchController.isActive) {
                destinationVC.subreddit = filteredSubreddits[indexPath.row]
            } else {
                destinationVC.subreddit = subRedditsArray[indexPath.row]
            }
            
            
        }
    }
}

//MARK: - SubReddits Delegate
extension SubRedditsViewController: SubredditsDelegate {
    func didGetSubreddits(_ redditRequestsManager: SubredditsRequestsManager, subreddits: [SubredditsModel]) {
        DispatchQueue.main.async {
            self.subRedditsArray.removeAll()
            self.subRedditsArray = subreddits
            self.stopActivityIndicator()
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - Search Bar Delegate
extension SubRedditsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredSubreddits.removeAll(keepingCapacity: false)
        filteredSubreddits = subRedditsArray.filter({$0.display_name_prefixed.localizedCaseInsensitiveContains(searchController.searchBar.text!)})
        self.tableView.reloadData()
    }
}
