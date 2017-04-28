//
//  PullRequestTableViewCell.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class PullRequestTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "PullRequestCell"
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //setup profile imageview
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightTitleColor.cgColor
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
    }
    
    func setup(pullRequest: PullRequest) {
        self.titleLabel.text = pullRequest.title
        self.numberLabel.text = "#\(pullRequest.number)"
        self.infoLabel.text = "opened on \(DateFormatters.shortFormatter.string(from: pullRequest.created)) by \(pullRequest.user?.login ?? ""))"
    }

    override func prepareForReuse() {
        self.profileImageView.image = UIImage(named: "blank_profile")
        self.titleLabel.text = ""
        self.numberLabel.text = ""
        self.infoLabel.text = ""
    }

}
