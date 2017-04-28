//
//  String+Lines.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/28/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

extension String {

    func numberOfLines(in label: UILabel) -> Int {
        let textStorage = NSTextStorage(string: self, attributes: [NSFontAttributeName: label.font])
        let size = CGSize(width: label.frame.size.width-16, height: label.frame.size.height)
        let textContainer = NSTextContainer(size: size)
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0
        
        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)
        
        var numberOfLines = 0
        var index = 0
        var lineRange : NSRange = NSMakeRange(0, 0)
        while index < layoutManager.numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return numberOfLines
    }
}
