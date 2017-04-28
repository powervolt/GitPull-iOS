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

extension Diff {
    
    enum DiffAttType {
        case added, removed, all
    }
    
    enum DiffLineType {
        case added, removed, unChanged, info, clear
    }
    
    func getAttributedDiff(for type: DiffAttType, label: UILabel? = nil) -> NSAttributedString {
        let attributedDiff = NSMutableAttributedString()
       
        var addedLineNumber = 0
        var removedLineNumber = 0
        
        var addQueue = Queue<(Int, String)>()
        var removeQueue = Queue<(Int, String)>()
        
        for line in self.changes {
            if (line.characters.count == 0) {
                continue
            }
           
            let firstChar = line.characters.first!
            
            if (line.matches(pattern: DiffRegexHelper.lineNumberPattern)) {
                var colorType: DiffLineType = .info
                if (type == .added) {
                    colorType = .clear
                }
                attributedDiff.append(self.getAttribute(forLine:line, type: colorType))
                if let addedNumber = Diff.getAddedLineNumber(fromInfo: line) {
                    addedLineNumber = addedNumber
                }
                
                if let removedNumber = Diff.getRemovedLineNumber(fromInfo: line) {
                    removedLineNumber = removedNumber
                }
              
            } else if firstChar == "-" {
                if (type == .all) {
                    attributedDiff.append(self.getAttribute(forLineNumber: removedLineNumber, type: .removed))
                    attributedDiff.append(self.getAttribute(forLine:line, type: .removed))
                } else {
                    removeQueue.enqueue((removedLineNumber, line))
                }
                
                removedLineNumber += 1
            
            } else if firstChar == "+" {
                if (type == .all) {
                    attributedDiff.append(self.getAttribute(forLineNumber: addedLineNumber, type: .added))
                    attributedDiff.append(self.getAttribute(forLine:line, type: .added))
                } else {
                    addQueue.enqueue((addedLineNumber, line))
                }
                
                addedLineNumber += 1
                
            } else if (firstChar == " ") { // unchanged
                if (type != .all) {
                    let attString = self.fillExtraSpace(type: type, addQueue:addQueue, removeQueue: removeQueue, label: label)
                    attributedDiff.append(attString)
                    // new cycle remove all
                    addQueue.dequeueAll()
                    removeQueue.dequeueAll()
                }
                
                var lineNumber = removedLineNumber
                if (type == .all || type == .added) {
                    lineNumber = addedLineNumber
                }
                
                attributedDiff.append(self.getAttribute(forLineNumber: lineNumber, type: .unChanged))
                attributedDiff.append(self.getAttribute(forLine:line, type: .unChanged))
                
                addedLineNumber += 1
                removedLineNumber += 1
                
            }
        }
        
        let attString = self.fillExtraSpace(type: type, addQueue: addQueue, removeQueue: removeQueue)
        attributedDiff.append(attString)
    
        return attributedDiff
    }
    
    //MARK: NSAttributedString Helpers
    private func fillExtraSpace(type: DiffAttType, addQueue: Queue<(Int, String)>, removeQueue: Queue<(Int, String)>, label: UILabel? = nil) -> NSAttributedString {
        
        var addQueue = addQueue
        var removeQueue = removeQueue
        
        
        var largerCount = addQueue.count
        
        if addQueue.count < removeQueue.count {
            largerCount = removeQueue.count
        }
        let attributedDiff = NSMutableAttributedString()
        
        
        while(largerCount > 0) {
            let addValue = addQueue.dequeue()
            let removeValue = removeQueue.dequeue()
            
            //append the appropriate diff value
            if (type == .added && addValue != nil) {
                attributedDiff.append(self.getAttribute(forLineNumber: addValue!.0, type: .added))
                attributedDiff.append(self.getAttribute(forLine:addValue!.1, type: .added))
            }
            
            if (type == .removed && removeValue != nil) {
                attributedDiff.append(self.getAttribute(forLineNumber: removeValue!.0, type: .removed))
                attributedDiff.append(self.getAttribute(forLine:removeValue!.1, type: .removed))
            }
            
            //check for sizing differnce on the change
            if let addValue = addValue, let removeValue = removeValue, let label = label {

                let numberOfLinesForAdd = self.getNumberOfLines(for: addValue, in: label)
                let numberOfLinesForRemove = self.getNumberOfLines(for: removeValue, in: label)
                
                let difference = numberOfLinesForAdd - numberOfLinesForRemove

                if (type == .added && difference < 0) {
                    for _ in 0...abs(difference) {
                        attributedDiff.append(self.getAttribute(forLine:"", type: .added))
                    }
                } else if (type == .removed && difference > 0) {
                    for _ in 0...difference {
                        attributedDiff.append(self.getAttribute(forLine:"", type: .clear))
                    }
                }
                
            } else if (type == .added && addValue == nil) {
                attributedDiff.append(self.getAttribute(forLineNumber: removeValue!.0, type: .clear))
                attributedDiff.append(self.getAttribute(forLine:removeValue!.1, type: .clear))
                
            } else if (type == .removed && removeValue == nil) {
                attributedDiff.append(self.getAttribute(forLineNumber: addValue!.0, type: .clear))
                attributedDiff.append(self.getAttribute(forLine:addValue!.1, type: .clear))
            }
            
            largerCount -= 1
        }
        
        return attributedDiff
    }
    
    private func getNumberOfLines(for value: (Int, String), in label: UILabel) -> Int {
        let lineNumber = self.getLineNumber(number: value.0)
        let fullString = lineNumber + value.1 + "\n"
    
        return fullString.numberOfLines(in: label)
    }
    
    private func getAttribute(forLine string: String, type: DiffLineType) -> NSAttributedString {
        let attString = NSMutableAttributedString(string: string + "\n")
         let range = NSMakeRange(0, attString.length)
        switch type {
        case .added:
            attString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffAddedColor, range: range)
            break
        case .removed:
            attString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffDeletedColor, range: range)
            break
        case .info:
            attString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffInfoColor, range: range)
            break
        case .clear:
            attString.addAttributes([NSBackgroundColorAttributeName: UIColor.lightTitleColor,
                                     NSForegroundColorAttributeName: UIColor.clear], range: range)
            break
        case .unChanged:
            break
        }
        
        return attString
    }
    
    private func getAttribute(forLineNumber number: Int, type: DiffLineType) -> NSAttributedString {
       
        let lineNumberString = self.getLineNumber(number: number)
        let range = NSMakeRange(0, lineNumberString.characters.count)
        let lineNumberAttString = NSMutableAttributedString(string: lineNumberString)
        lineNumberAttString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: range)
        
        switch type {
        case .added:
            lineNumberAttString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffDarkAddedColor, range: range)
            break
        case .removed:
            lineNumberAttString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.diffDarkDeletedColor, range: range)
            break
        case .info:
            lineNumberAttString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clear, range: range)
            break
        case .clear:
            lineNumberAttString.addAttributes([NSBackgroundColorAttributeName: UIColor.lightTitleColor,
                                     NSForegroundColorAttributeName: UIColor.clear], range: range)

        case .unChanged:
            break
        }
        
        return lineNumberAttString
    }
    
    private func getLineNumber(number: Int) -> String {
        return "\(number):"
    }
}
