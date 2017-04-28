//
//  PullRequestTableViewController.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class PullRequestTableViewController: UITableViewController {
    
    var pullRequests: [PullRequest] = []
    let service = GitPRServiceImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableViewCell()
        self.setupRefreshControl()
        
        self.refreshControl?.beginRefreshing()
        self.fetchData()
    }
    
    func fetchData() {
        service.getPullRequests(status: .Open) { (pullRequests, error) in
            if let pullRequests = pullRequests {
                self.pullRequests = pullRequests.sorted(by: {$0.number > $1.number})
                DispatchQueue.main.async {
                    self.navigationItem.title = "Pull Requests (\(self.pullRequests.count))"
                    self.tableView.reloadData()
                    if (self.refreshControl?.isRefreshing ?? false) {
                        self.refreshControl?.endRefreshing()
                    }
                }
            }
        }
    }
    
    private func setupTableViewCell() {
        let nib = UINib(nibName: "PullRequestCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: PullRequestTableViewCell.reuseIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pullRequests.count
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PullRequestTableViewCell.reuseIdentifier, for: indexPath)

        if let cell = cell as? PullRequestTableViewCell {
            let pr = pullRequests[indexPath.row]
            cell.setup(pullRequest: pr)
            
            if let avatarUrl = pr.user?.avatarUrl {
                service.downloadUserAvatar(avatarUrl: avatarUrl, completionHandler: { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            cell.profileImageView?.image = image
                        }
                    }
                })
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Diff", bundle: nil)
        if let vc = storyBoard.instantiateInitialViewController() as? DiffTableViewController {
            let pr = self.pullRequests[indexPath.row]
            vc.pullRequest = pr
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
