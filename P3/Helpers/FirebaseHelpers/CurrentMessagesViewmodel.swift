//
//  CurrentMessagesViewmodel.swift
//  P3
//
//  Created by Amos Cha on 4/24/22.
//

import Foundation
import SwiftUI


class currentMessageVM: ObservableObject {

    @Published var users = [CurrentUser]()
    @Published var errorMessage = ""

    init() {
        //temporarily fetch all users
        fetchAllUsers()
    }

    func reload() {
        users.removeAll()
        fetchAllUsers()
    }
    func fetchAllUsers() {
        firebaseManager.shared.firestore.collection("users")
            .getDocuments { availableUsers, error in
                if let error = error {
                    print("Failed to fetch users: \(error)")
                    return
                }

                availableUsers?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = CurrentUser(data: data)
                    if user.uid != firebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(.init(data: data))
                    }

                })
            }
    }
}
