//
//  DiffRegexHelper.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/27/17.
//  Copyright © 2017 Bipin. All rights reserved.
//


class DiffRegexHelper {
    
    static let gitDiffPattern = "^diff --git a\\/.* b\\/.*"
    static let lineNumberPattern = "@@\\s[-]\\d*\\,\\d*\\s[+]\\d*,?\\d*\\s@@"
    static let lineAddedNumberExtractPattern = "\\s[+]\\d*"
    static let lineRemovedNumberExtractPattern = "\\s[-]\\d*"
    static let deletedFileModePattern = "^deleted file mode \\d*"
    static let newFileModePattern = "^new file mode \\d*"
    static let fileNameExtractPattern = "a\\/.* b\\/"
    static let renamedFilePattern = "similarity index \\d*%$"
    static let similarityPercentage = "\\d{1,3}%$"
}
