//
//  CurrentMessagesViewmodel.swift
//  P3
//
//  Created by Amos Cha on 4/24/22.
//

import Foundation
import SwiftUI


class ContactVM: ObservableObject {

    @Published var users = [CurrentUser]()
    @Published var errorMessage = ""

    init() {
        //temporarily fetch all users
//        fetchAllUsers()

    }

    func reload() {
        users.removeAll()
        fetchAllUsers()
    }
    func fetchAllUsers() {
        let uid: String = firebaseManager.shared.auth.currentUser?.uid  ?? ""
        firebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { snapshot, error in
                if let error = error {
                    print("Failed to fetch user: \(error)")
                    return
                }
                let contacts = snapshot?.data()?["contacts"] as? Array<String>
                contacts?.forEach({contactUid in
                    firebaseManager.shared.firestore.collection("users")
                        .document(contactUid).getDocument { snapshot, error in
                            if let error = error {
                                print("Failed to fetch user: \(error)")
                                return
                            }
                            guard let data = snapshot?.data() else {
                                return
                            }
                            let user = CurrentUser(data: data)
                            if user.uid != firebaseManager.shared.auth.currentUser?.uid {
                                self.users.append(.init(data: data))
                            }
                        }
                })
            }
    }
}
