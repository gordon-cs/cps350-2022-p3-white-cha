//
//  createMessage.swift
//  P3
//
//  Created by Amos Cha on 4/23/22.
//
import SwiftUI
import FirebaseDatabase


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

struct createMessage: View {
    let didSelectUser: (CurrentUser) -> ()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = createMessageVM()
    
    @State var contactArray: Array<String> = []

    var ref: DatabaseReference = firebaseManager.shared.RTDB.child("users")

    private func observeData() {
        ref.child(firebaseManager.shared.auth.currentUser!.uid).child("contacts").observe(.value, with: {(snapshot) in
            contactArray = snapshot.value as? Array<String> ?? []
        })
    }
    
    
    func addContact(uid: String) {
        let currentUid: String = firebaseManager.shared.auth.currentUser?.uid ?? ""
        firebaseManager.shared.RTDB.updateChildValues(["/users/\(uid)/messages" : [currentUid: 0]])
        firebaseManager.shared.RTDB.updateChildValues(["/users/\(currentUid)/messages" : [uid: 0]])
        contactArray.insert(uid, at: 0)
        ref.child(firebaseManager.shared.auth.currentUser!.uid).child("contacts").setValue(contactArray)
        ref.child(uid).child("contacts").getData(completion:  {error, snapshot in
            var otherContactArray = snapshot.value as? Array<String> ?? [];
            otherContactArray.insert(firebaseManager.shared.auth.currentUser!.uid, at: 0)
            ref.child(uid).child("contacts").setValue(otherContactArray)
        });
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.users) { user in
                    Button {
                        addContact(uid: user.uid)
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
        .onAppear{
            observeData()
        }
    }
}
