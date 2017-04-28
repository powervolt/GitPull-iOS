//
//  DiffTableViewCell.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class DiffTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "DiffTableViewCell"
    @IBOutlet weak var diffLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(diff: Diff) {
        self.fileNameLabel.text = diff.fileName
        diffLabel.attributedText = diff.getAttributedDiff(for: .all)
    }
}
