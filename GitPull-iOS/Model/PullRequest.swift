//
//  PullRequest.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import Foundation

struct PullRequest {
    private(set) var title: String
    private(set) var diffUrl: String
    private(set) var number: Int
    private(set) var state: String
    private(set) var user: User?
    private(set) var locked: Bool
    private(set) var created: Date
    
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String  else {
            return nil
        }
        
        guard let diffUrl = dictionary["diff_url"] as? String  else {
            return nil
        }
        
        guard let number = dictionary["number"] as? Int  else {
            return nil
        }
        
        guard let locked = dictionary["locked"] as? Bool  else {
            return nil
        }
        
        guard let state = dictionary["state"] as? String  else {
            return nil
        }
        
        guard let dateString = dictionary["created_at"] as? String  else {
            return nil
        }
        
        self.created = DateFormatters.UTCformatter.date(from: dateString)!
        
        self.title = title
        self.diffUrl = diffUrl
        self.number = number
        self.locked = locked
        self.state = state
        
        if let userDict = dictionary["user"] as? [String : Any] {
            if let user = User(dictionary: userDict) {
                self.user = user
            }
        }
        
    }
}

extension PullRequest {
    static func getPullReqests(serviceData: [Any]) -> [PullRequest] {
        var pullRequests: [PullRequest] = []
        for prData in serviceData {
            if let prData = prData as? [String : Any] {
                let pullRequest = PullRequest(dictionary: prData)
                if let pullRequest = pullRequest {
                    pullRequests.append(pullRequest)
                }
            }
        }
        
        return pullRequests
    }
}
