//
//  UIColor+DiffColor.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/26/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

extension UIColor {

    static var lightTitleColor: UIColor {
        get {
            return UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.0)
        }
    }
    
    static var diffAddedColor: UIColor {
        get {
            return UIColor(red:0.92, green:1.00, blue:0.92, alpha:1.0)
        }
    }
    
    static var diffDeletedColor: UIColor {
        get {
            return UIColor(red:1.00, green:0.93, blue:0.93, alpha:1.0)
        }
    }
    
    static var diffInfoColor: UIColor {
        get {
            return UIColor(red:0.96, green:0.97, blue:1.00, alpha:1.0)
        }
    }
    
    static var diffDarkAddedColor: UIColor {
        get {
            return UIColor(red:0.92, green:1.00, blue:0.92, alpha:1.0)
        }
    }
    
    static var diffDarkDeletedColor: UIColor {
        get {
            return UIColor(red:1.00, green:0.93, blue:0.93, alpha:1.0)
        }
    }
    
    static var diffDarkInfoColor: UIColor {
        get {
            return UIColor(red:0.96, green:0.97, blue:1.00, alpha:1.0)
        }
    }
}


