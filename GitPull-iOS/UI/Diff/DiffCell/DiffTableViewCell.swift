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
        //diffLabel.text = diff.changes.joined(separator: "\n")
        self.fileNameLabel.text = diff.fileName
        let attText = NSMutableAttributedString()
        
        var currentLineNumber = diff.startingLineNumber ?? 0
        var skipAppendLineNumber = false;
        
        for line in diff.changes {
            if (line.characters.count == 0) {
                continue
            }
            
            //line number 
            let lineNumberString = "\(currentLineNumber):"
            let lineNumberRange = NSMakeRange(0, lineNumberString.characters.count)
            let lineNumber = NSMutableAttributedString(string: lineNumberString)
            lineNumber.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: lineNumberRange)
            
            let atString = NSMutableAttributedString(string: line + "\n")
            let firstChar = line.characters.first!
            let range = NSMakeRange(0, line.characters.count)
            
            if firstChar == "-" {
                atString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffDeletedColor, range: range)
                lineNumber.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffDeletedColor, range: lineNumberRange)
            } else if firstChar == "+" {
                atString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffAddedColor, range: range)
                 lineNumber.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffAddedColor, range: lineNumberRange)
            } else if (line.matches(pattern: Diff.lineNumberPattern)) {
                atString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffInfoColor, range: range)
                lineNumber.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffInfoColor, range: lineNumberRange)
                lineNumber.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear, range: lineNumberRange)
                
                //get new line number
                if let number = diff.getLineNumber(fromInfo: line) {
                    currentLineNumber = number
                }
                skipAppendLineNumber = true
            }
            
            if skipAppendLineNumber {
                skipAppendLineNumber = false
            } else {
                currentLineNumber = currentLineNumber + 1
            }
            attText.append(lineNumber)
            attText.append(atString)
        }
        
        diffLabel.attributedText = attText
    }

    
    override func prepareForReuse() {
        
    }

}
