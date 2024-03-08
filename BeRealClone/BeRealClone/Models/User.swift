//
//  User.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/7/24.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    var username: String?
    
    var email: String?
    
    var emailVerified: Bool?
    
    var password: String?
    
    var authData: [String : [String : String]?]?
    
    var originalData: Data?
    
    var objectId: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var ACL: ParseSwift.ParseACL?
    
    
}
