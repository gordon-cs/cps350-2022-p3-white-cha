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

struct createMessage: View {
    
    let didSelectUser: (CurrentUser) -> ()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = createMessageVM()

     
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.users) { user in
                    Button {
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

struct createMessage_Previews: PreviewProvider {
    static var previews: some View {
//        createMessage()
        MessageView()
    }
}
