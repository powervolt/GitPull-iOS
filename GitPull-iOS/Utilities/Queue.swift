//
//  Queue.swift
//  GitPull-iOS
//
//  Created by Bipin on 4/28/17.
//  Copyright © 2017 Bipin. All rights reserved.
//

import UIKit

struct Queue<T> {
    fileprivate var array = [T]()
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    var front: T? {
        return array.first
    }
    
    mutating func dequeueAll() {
        array.removeAll()
    }
}
