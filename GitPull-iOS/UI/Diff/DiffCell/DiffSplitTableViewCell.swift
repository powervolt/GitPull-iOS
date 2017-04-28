//
//  DiffSplitTableViewCell.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/27/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class DiffSplitTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "DiffSplitTableViewCell"
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var rightDiffLabel: UILabel!
    @IBOutlet weak var leftDiffLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(diff: Diff) {
        self.fileNameLabel.text = diff.fileName
        rightDiffLabel.attributedText = diff.getAttributedDiff(for: .added, label: rightDiffLabel)
        leftDiffLabel.attributedText = diff.getAttributedDiff(for: .removed, label: leftDiffLabel)
    }
}
