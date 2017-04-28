//
//  Diff.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

enum DiffType {
    case new, deleted, renamed, normal
}

struct Diff {
        
    private(set) var fileName: String
    private(set) var info: String?
    private(set) var changes: [String]
    private(set) var type: DiffType = .normal
    
    init?(diffLines: [String]) {
        //check if new or deleted file
        
        guard let name = Diff.getFileName(string: diffLines[0]) else {
            return nil
        }
        
        self.fileName = name
         // TODO similarity rename and change rename
        var metaIndex = 0
        for line in diffLines {
            if (line.matches(pattern: DiffRegexHelper.lineNumberPattern)) { // end of meta data
                self.info = diffLines[metaIndex]
                break
            } else if (line.matches(pattern: DiffRegexHelper.newFileModePattern)) {
                self.type = .new
            } else if (line.matches(pattern: DiffRegexHelper.deletedFileModePattern)) {
                self.type = .deleted
            } else if (line.matches(pattern: DiffRegexHelper.renamedFilePattern)) {
                self.type = .renamed
                let simailartyPercentage = line.matchingString(pattern: DiffRegexHelper.similarityPercentage)
                if (simailartyPercentage == "100%") {
                    self.changes = []
                    return
                }
            }
            
             metaIndex += 1
        }
        
        if (diffLines.count-1 > metaIndex) {
            let changes: ArraySlice<String> = diffLines[metaIndex...diffLines.count-1]
            self.changes = Array(changes)
        } else {
            self.changes = []
        }
    }
}

// MARK: Regex Parser Helper
extension Diff {
    static func getAddedLineNumber(fromInfo string: String) -> Int? {
        let linePattern = string.matchingString(pattern: DiffRegexHelper.lineNumberPattern)
        if let linePattern = linePattern {
            if let numberPattern = linePattern.matchingString(pattern: DiffRegexHelper.lineAddedNumberExtractPattern) {
                return Int(numberPattern.replacingOccurrences(of: " +", with: ""))
            }
        }
        
        return nil
    }
    
    static func getRemovedLineNumber(fromInfo string: String) -> Int? {
        let linePattern = string.matchingString(pattern: DiffRegexHelper.lineNumberPattern)
        if let linePattern = linePattern {
            if let numberPattern = linePattern.matchingString(pattern: DiffRegexHelper.lineRemovedNumberExtractPattern) {
                return Int(numberPattern.replacingOccurrences(of: " -", with: ""))
            }
        }
        
        return nil
    }

    
    static func getFileName(string: String) -> String? {
        let matches = string.matches(pattern: DiffRegexHelper.gitDiffPattern)
        if (matches) {
            if let linePattern = string.matchingString(pattern: DiffRegexHelper.fileNameExtractPattern) {
                let range = NSRange(location: 2, length: linePattern.characters.count - 5)
                return linePattern.substring(with: range)
            }
        }
        
        return nil
    }
}
