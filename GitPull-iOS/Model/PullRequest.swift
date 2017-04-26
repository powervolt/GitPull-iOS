//
//  PullRequest.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

class PullRequest {

    var title: String
    var diffUrl: String
    var number: Int
    var state: String
    var user: User?
    var locked: Bool
    
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
