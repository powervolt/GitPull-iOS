//
//  LargeDiffTableViewCell.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class LargeDiffTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "LargeDiffTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(diffType: DiffType) {
        switch diffType {
        case .deleted:
            titleLabel.text = "Deleted File"
            titleLabel.textColor = UIColor.red
            subTitleLabel.text = "Tap to view changes"
            break
        case .new:
            titleLabel.text = "File Added"
            titleLabel.textColor = UIColor.green
            subTitleLabel.text = "Tap to view changes"
            break
        case .renamed:
            titleLabel.text = "File Renamed"
            titleLabel.textColor = UIColor.yellow
            subTitleLabel.text = "Tap to view changes"
            break
        default:
            titleLabel.text = "Large Diff"
            titleLabel.textColor = UIColor.blue
            subTitleLabel.text = "Large diffs are not rendered by default"
        }
    }
}
