//
//  User.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

struct User {

    var login: String
    var avatarUrl: String?
    
    init?(dictionary: [String : Any]) {
        guard let login = dictionary["login"] as? String  else {
            return nil
        }
        
        self.login = login
        if let url = dictionary["avatar_url"] as? String {
            self.avatarUrl = url
        }
    }
}
