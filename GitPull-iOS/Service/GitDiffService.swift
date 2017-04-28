//
//  GitDiffService.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

typealias DiffCompletionHandler = (_ string: String?, _ error: Error?) -> Void

protocol GitDiffService {
    func getDiff(url: String, completionHandler: @escaping DiffCompletionHandler)
}

class GitDiffServiceImpl: GitDiffService {
 
    private let serviceHelper: BaseRESTService
    
    init(restHelper: BaseRESTService = BaseRESTServiceImpl()) {
        self.serviceHelper = restHelper
    }
    
    func getDiff(url: String, completionHandler: @escaping DiffCompletionHandler) {
        serviceHelper.sendRequest(url: url, method: .Get, headers: GitServiceConstants.defaultHeaders) { (data, status, error) in
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            if status == 200 {
                guard let data = data else {
                    let error = NSError(domain: "Data is empty", code: status, userInfo: nil)
                    completionHandler(nil, error)
                    return
                }
                
                let diffString = String(data: data, encoding: .utf8)
                completionHandler(diffString, nil)
                
            } else {
                
                var error = NSError(domain: "Unable to retrive diff", code: status, userInfo: nil)
                if let data = data {
                    if let diffString = String(data: data, encoding: .utf8) {
                        error = NSError(domain: diffString, code: status, userInfo: nil)
                    }
                }
                completionHandler(nil, error)
            }
        }
    }
}
