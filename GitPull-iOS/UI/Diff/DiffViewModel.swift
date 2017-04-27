//
//  DiffViewModel.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

typealias CompletionHandler = (_ error: Error?) -> Void

class DiffViewModelImpl {
    
    let diffService: GitDiffService
    var diffArray: [Diff] = []
    var diffReloadIndex: Set<Int> = []
    init(service: GitDiffService = GitDiffServiceImpl()) {
        self.diffService = service
    }
    
    func fetchData(url: String, completionHandler: @escaping CompletionHandler) {
        self.diffService.getDiff(url: url) { (diffString, error) in
            if let error = error {
                completionHandler(error)
            } else {
                if let diffString = diffString {
                  self.populateData(string: diffString)
                }
                
                completionHandler(nil)
            }
        }
    }
    
    func populateData(string: String) {
        let stringArray = string.components(separatedBy: .newlines)
        func appendData(start:Int, end:Int) {
            let newArray: ArraySlice<String> = stringArray[start...end]
            let diff = Diff(diff: Array(newArray))
            if let diff = diff {
                diffArray.append(diff)
            }
        }
        
        var first = true
        var topIndex = 0
        for index in 0..<stringArray.count {
            let line = stringArray[index]
          
            if (line.characters.count == 0) {
                continue
            }
            
            let firstChar = line.characters.first!
            //if line starts with "Diff"
            if (firstChar == "d" && line.contains("diff --git")) {
                if (!first) {
                    appendData(start: topIndex, end: index-1)
                    topIndex = index
                } else {
                    first = false
                }
            }
        }
        
        appendData(start: topIndex, end: stringArray.count-1)
    }
    
    func shouldHideFullDiff(index: Int) -> Bool {
        if self.diffArray[index].changes.count > 40 && !self.diffReloadIndex.contains(index) {
            return true
        }
        
        return false
    }
}


