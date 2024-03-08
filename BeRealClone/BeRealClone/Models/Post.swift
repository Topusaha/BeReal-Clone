//
//  Post.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/8/24.
//

import Foundation
import ParseSwift


struct Post: ParseObject {
    var originalData: Data?
    
    var objectId: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var ACL: ParseSwift.ParseACL?
    
    var user: User?
    var captain: String?
    var imageFile: ParseFile?
}
