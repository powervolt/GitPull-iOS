//
//  String+Regex.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

extension String {

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(with r: NSRange) -> String {
        let startIndex = index(from: r.location)
        let endIndex = index(from: r.location + r.length)
        return substring(with: startIndex..<endIndex)
    }
    
    func matches(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: [.caseInsensitive])
            return regex.firstMatch(
                in: self,
                options: [],
                range: NSRange(location: 0, length: utf16.count)) != nil
        }
        catch{
            return false
        }
    }
    
    func matchingString(pattern: String) -> String? {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: [.caseInsensitive])
            let match = regex.matches(in: self, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: utf16.count)).first
            if let match = match {
                return substring(with: match.range)
            }
        }
            
        catch{
            return nil
        }
        return nil
    }
}
