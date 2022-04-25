//
//  MessageViewmodel.swift
//  P3
//
//  Created by Amos Cha on 4/24/22.
//

import Foundation

/*
 * Observable Object for firebase fetch
 */
class MessageViewmodel: ObservableObject {
    @Published var msg = ""
    @Published var currentUser: CurrentUser?
    @Published var isLoggedOut = true
    
    init() {
//        test()
        DispatchQueue.main.async {
            self.isLoggedOut =
            firebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        
    }
    
    func reload() {
        fetchCurrentUser()
    }
    
    
    /*
        AUTO LOG IN TEST ACCOUNT, COMMENT OUT TEST FUNCTION AND test() on line 20 for functionality
     */
    func test() {
        firebaseManager.shared.auth.signIn(withEmail: "testing@testing.com", password: "testing") {
            result, e in
            if let e = e {
                print("Failed to log into user:", e)
                return
            }
        }
    }

    
    func fetchCurrentUser() {

        guard let uid = firebaseManager.shared.auth.currentUser?.uid else {
            self.msg = "Could not find firebase uid"
            return
        }
        
        self.msg = "\(uid)"

        firebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.msg = "unable to fetch user: \(error)"
                print("unable to fetch user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.msg = "no data"
                return
            }
            
            self.currentUser = .init(data: data)
        }
    }
    
    
    
    func signOut() {
        isLoggedOut.toggle()
        try? firebaseManager.shared.auth.signOut()
    }
}
