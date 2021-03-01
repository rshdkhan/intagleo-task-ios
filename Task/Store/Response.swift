//
//  Response.swift
//  Task
//
//  Created by Rashid Khan on 3/1/21.
//

import Foundation

enum Status {
    case success
    case failure
}

struct Response<T> {
    var status: Status
    var failureMsg: String?
    var data: T?
    
    init(withData data: T) {
        self.status = .success
        self.data = data
    }
    
    init(withFailureMessage message: String) {
        self.status = .failure
        self.failureMsg = message
    }
}
