//
//  BaseRESTService.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case Get = "GET"
    case Post = "POST"
}

typealias RESTCompletionHandler = (_ data: Data?, _ statusCode: Int, _ error: Error?) -> Void
typealias ImageDownloadCompletionHandler = (_ fileUrl: URL?, _ error: Error?) -> Void

protocol BaseRESTService: class {
  func sendRequest(url: String, method: HTTPMethod, headers: [String : String]?, completionHandler: @escaping RESTCompletionHandler)
    func downloadImage(url: String, completionHandler: @escaping ImageDownloadCompletionHandler)
}

class BaseRESTServiceImpl: BaseRESTService {
    func sendRequest(url: String, method: HTTPMethod, headers: [String : String]?, completionHandler: @escaping RESTCompletionHandler) {
        if let requestURL = URL(string: url) {
            var request = URLRequest(url: requestURL)
            request.httpMethod = method.rawValue
            
            if let headers = headers {
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                NetworkActivityIndicatorHelper.setIndicator(false)
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "Error reading response", code: 500, userInfo: nil)
                    completionHandler(nil, 500, error)
                    return
                }
                
                completionHandler(data, httpResponse.statusCode, error)
                
            })
            
            NetworkActivityIndicatorHelper.setIndicator(true)
            task.resume()
            
        } else {
            let error = NSError(domain: "Invalid url", code: 500, userInfo: nil)
            completionHandler(nil, 500, error)
        }
    }
    
    func downloadImage(url: String, completionHandler: @escaping ImageDownloadCompletionHandler) {
       
        if let url = URL(string: url) {
            let fileName = url.lastPathComponent
            let downloadLocation = self.getDownloadLocation(fileName: fileName)
            
            if (FileManager.default.fileExists(atPath: downloadLocation.relativePath)) {
                completionHandler(downloadLocation, nil)
                return
            }
            
            NetworkActivityIndicatorHelper.setIndicator(true)
            let downloadTask = URLSession.shared.downloadTask(with: url) { (url, _ , error) in
                NetworkActivityIndicatorHelper.setIndicator(false)
                if let url = url {
                    
                    do {
                     try FileManager.default.copyItem(at: url, to: downloadLocation)
                    }
                    catch let error {
                        completionHandler(nil, error)
                        return
                    }
                    
                    completionHandler(downloadLocation, nil)
                    return
                }
                
                completionHandler(nil, error)
                return
            }
            
            downloadTask.resume()
        }
        
        let error = NSError(domain: "Invalid Url", code: 500, userInfo: nil)
        completionHandler(nil, error)
    }
    
    //MARK: Helper
    private func getDownloadLocation(fileName: String) -> URL {
        return  URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
    }
}
