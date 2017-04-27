//
//  Diff.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

enum DiffType {
    case New, Deleted, Renamed
}

struct Diff {
    
    private(set) var fileName: String
    private(set) var info: String
    private(set) var changes: [String]
    private(set) var type: DiffType?
    
    
    init?(diff: [String]) {
        //check if new or deleted file
        
        if(diff.count) < 5 {
            debugPrint("Diff count less then 5\n:  \(diff)")
            return nil
        }
        
        var offSet = 0
        let secondLine = diff[2]
        if secondLine.contains("new file mode") {
            self.type = .New
            offSet += 1
        } else if secondLine.contains("deleted file mode") {
            self.type = .Deleted
            offSet += 1
        }
        
        // TODO similarity rename and change rename
        let changes: ArraySlice<String> = diff[5+offSet...diff.count-1]
        self.changes = Array(changes)
        self.fileName = diff[2+offSet].replacingOccurrences(of: "--- a/", with: "")
        self.info = diff[4+offSet]
    }
}
