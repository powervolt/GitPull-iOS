//
//  NetworkActivityIndicatorHelper.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

class NetworkActivityIndicatorHelper {
    static func setIndicator(_ visible: Bool) {
        
        struct CallToVisible {
            static var count = 0
        }
        
        if (visible) {
            CallToVisible.count += 1
        } else {
            if (CallToVisible.count > 0){
                CallToVisible.count -= 1
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = CallToVisible.count > 0
    }
}


