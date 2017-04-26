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
        self.setupTableView()
    
        service.getPullRequests(status: .Open) { (pullRequests, error) in
            if let pullRequests = pullRequests {
                self.pullRequests = pullRequests
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "PullRequestCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: PullRequestTableViewCell.reuseIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequests.count
    }

    
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
}
