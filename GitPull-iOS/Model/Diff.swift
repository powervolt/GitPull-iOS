    static let lineNumberPattern = "@@\\s[+-]?\\d*\\,-?\\d*\\s[+-]?\\d*,\\d*\\s@@"
    static let lineNumberExtractPattern = "\\s[+]\\d*"
    
    private(set) var startingLineNumber: Int?
        
        self.startingLineNumber = getLineNumber(fromInfo: self.info)
    }
    
    func getLineNumber(fromInfo string: String) -> Int? {
        let linePattern = string.matchingString(pattern: Diff.lineNumberPattern)
        if let linePattern = linePattern {
            if let numberPattern = linePattern.matchingString(pattern: Diff.lineNumberExtractPattern) {
                return Int(numberPattern.replacingOccurrences(of: " +", with: ""))
            }
        }
        
        return nil