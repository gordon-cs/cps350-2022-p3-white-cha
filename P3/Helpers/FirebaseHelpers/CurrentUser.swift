//
//  CurrentUser.swift
//  P3
//
//  Created by Amos Cha on 4/8/22.
//

import Foundation


struct CurrentUser {
    let uid, email, imgURL: String
    
    init(data: [String: Any]) {
        
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.imgURL = data["imgURL"] as? String ?? ""
    }
}
