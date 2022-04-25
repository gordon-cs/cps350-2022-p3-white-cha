//
//  createMessage.swift
//  P3
//
//  Created by Amos Cha on 4/23/22.
//
import SwiftUI


class createMessageVM: ObservableObject {

    @Published var users = [CurrentUser]()
    @Published var errorMessage = ""

    init() {
        fetchAllUsers()
    }

    private func fetchAllUsers() {
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

func addContact(uid: String, vm: ContactVM) {
    let currentUid: String = firebaseManager.shared.auth.currentUser?.uid ?? ""

    firebaseManager.shared.RTDB.updateChildValues(["/users/\(uid)/messages" : [currentUid: 0]])
    firebaseManager.shared.RTDB.updateChildValues(["/users/\(currentUid)/messages" : [uid: 0]])
    firebaseManager.shared.firestore.collection("users")
        .document(currentUid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch user: \(error)")
                return
            }
            var contacts = snapshot!.data()!["contacts"]! as! [Any]
            contacts.append(uid)
            firebaseManager.shared.firestore.collection("users").document(currentUid).updateData(["contacts": contacts])
        }
    firebaseManager.shared.firestore.collection("users")
        .document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch user: \(error)")
                return
            }
            var contacts = snapshot!.data()!["contacts"]! as! [Any]
            vm.users.append(.init(data: snapshot!.data()!))
            contacts.append(currentUid)
            firebaseManager.shared.firestore.collection("users").document(uid).updateData(["contacts": contacts])
        }
}

struct createMessage: View {
    let contactVM: ContactVM
    let didSelectUser: (CurrentUser) -> ()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = createMessageVM()

     
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.users) { user in
                    Button {
                        addContact(uid: user.uid, vm: contactVM)
                        presentationMode.wrappedValue.dismiss()
                        didSelectUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            
                            AsyncImage(url: URL(string: user.imgURL ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                
                                
                            } placeholder: {
                                Image(systemName: "person.fill")
                                    .font(.system(size:34))
                                    .foregroundColor(Color(.gray))
                                    .padding(7)
                            }
                            
                            
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            
                            //forced left
                            Spacer()
                            
                            
                        }.padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 5)
                }
                
            }
            .navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                       
                }
        }
    }
}
