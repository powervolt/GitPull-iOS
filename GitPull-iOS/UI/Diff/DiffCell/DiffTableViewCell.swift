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
        // Initialization code
    }
    
    func setup(diff: Diff) {
        diffLabel.text = diff.changes.joined(separator: "\n")
        self.fileNameLabel.text = diff.fileName
        let attText = NSMutableAttributedString()
        for line in diff.changes {
            if (line.characters.count == 0) {
                continue
            }
            
            let atString = NSMutableAttributedString(string: line + "\n")
            let firstChar = line.characters.first!
            let range = NSMakeRange(0, line.characters.count)
            
            if firstChar == "-" {
                atString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffDeletedColor, range: range)
            } else if firstChar == "+" {
                atString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffAddedColor, range: range)
            }
            
            attText.append(atString)
        }
        
        diffLabel.attributedText = attText
        self.bringSubview(toFront: diffLabel)
        
    }

    override func prepareForReuse() {
        
    }

}
