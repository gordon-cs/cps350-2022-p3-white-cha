//
//  CurrentUser.swift
//  P3
//
//  Created by Amos Cha on 4/8/22.
//
import Foundation


struct User: Identifiable {
    
    var id: String { uid }
    let uid, email, imgURL: String
    let contacts: Array<Any>
    
    init(data: [String: Any]) {
        
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.imgURL = data["imgURL"] as? String ?? ""
        self.contacts = data["contacts"] as? Array<Any> ?? []
        
    }
}


struct RecentInformation: Identifiable {
    var id: String { uid }
    let uid, lastMessage, lastTime: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.lastTime = data["lastTine"] as? String ?? ""
        self.lastMessage = data["lastMessage"] as? String ?? ""
    }
}
