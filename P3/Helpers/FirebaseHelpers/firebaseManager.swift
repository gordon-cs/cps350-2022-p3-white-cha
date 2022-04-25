//
//  firebaseManager.swift
//  P3
//
//  Created by Amos Cha on 4/8/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase


/*
 Singleton FirebaseApp to prevent reconfigure crash
 */
class firebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    var RTDB: DatabaseReference!
    //singleton
    static let shared = firebaseManager()
    
    override init () {
        FirebaseApp.configure()
        self.RTDB = Database.database().reference()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
    
}
