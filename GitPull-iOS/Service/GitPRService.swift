//
//  GitPRService.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

typealias GitPRCompletionHandler = (_ pullRequests: [PullRequest]?, _ error: Error?) -> Void
typealias GitAvatarImageCompletionHanlder = (_ image: UIImage?) -> Void

enum PullRequestStatus: String {
    case Open = "open"
    case Close = "close"
    case All = "all"
}

protocol GitPRService {
  func getPullRequests(status: PullRequestStatus, completionHandler: @escaping GitPRCompletionHandler)
  func downloadUserAvatar(avatarUrl: String, completionHandler: @escaping GitAvatarImageCompletionHanlder)
}

class GitPRServiceImpl: GitPRService {
    private let restHelper: BaseRESTService
    
    init(restHelper: BaseRESTService = BaseRESTServiceImpl()) {
        self.restHelper = restHelper
    }
    
    func getPullRequests(status: PullRequestStatus, completionHandler: @escaping GitPRCompletionHandler) {
        let url = String(format: GitServiceConstants.repoUrl, status.rawValue)
        self.restHelper.sendRequest(url: url, method: .Get, headers: GitServiceConstants.defaultHeaders) { (data, status, error) in
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            if (status == 200) {
                guard let data = data else {
                    let error = NSError(domain: "No Data returned from server", code: status, userInfo: nil)
                    completionHandler(nil, error)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
                        let pullRequests = PullRequest.getPullReqests(serviceData: json)
                        completionHandler(pullRequests, error)
                        return
                    } else {
                        let error = NSError(domain: "Unable to parse data", code: status, userInfo: nil)
                        completionHandler(nil, error)
                        return
                    }
                } catch let error {
                    completionHandler(nil, error)
                    return
                }
            } else {
        
                let error = NSError(domain: "Error retriving pull requests", code: status, userInfo: nil)
                completionHandler(nil, error)
            }
        }
    }
    
    func downloadUserAvatar(avatarUrl: String, completionHandler: @escaping GitAvatarImageCompletionHanlder) {
        self.restHelper.downloadImage(url: avatarUrl) { (fileUrl, error) in
            if let fileUrl = fileUrl {
                if let data = FileManager.default.contents(atPath: fileUrl.relativePath) {
                    completionHandler(UIImage(data: data))
                    return
                }
            }
            
            completionHandler(nil)
        }
    }
}
