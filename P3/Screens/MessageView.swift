//
//  MessageView.swift
//  P3
//
//  Created by Amos Cha on 4/4/22.
//

import SwiftUI


/*
 * Observable Object for firebase fetch
 */
class MessageViewmodel: ObservableObject {
    @Published var msg = ""
    @Published var currentUser: CurrentUser?
    @Published var isLoggedOut = false
    
    init() {
        DispatchQueue.main.async {
            self.isLoggedOut =
            firebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        
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



struct MessageView: View {
    
    @ObservedObject private var viewmodel = MessageViewmodel()
    @State var logoutOptions = false
    
    //Custom Nav Bar
    var NavBar: some View {
//        Text("\(viewmodel.msg)")
        
        HStack {
            //profile pic
            VStack {
                Button {
                    //change profile picture button
                } label: {
                    AsyncImage(url: URL(string: viewmodel.currentUser?.imgURL ?? "")) { image in
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
                    
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.gray, lineWidth: 2))
            
            //name & status
            
            VStack (alignment: .leading, spacing: 2) {
                Text("\(viewmodel.currentUser?.email ?? "")")
                    .font(.system(size: 24))
                
                HStack {
                    Circle()
                        .foregroundColor(Color(.lightGray))
                        .frame(width: 14, height: 14)
                    Text("online_status")
                        .font(.system(size: 14))
                }
                
                
            }
            .padding(.horizontal)
            
            Spacer()
            
            //settings
            Button {
                logoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 25))
                    .foregroundColor(Color(.gray))
            }
            
        }
        .padding()
        .actionSheet(isPresented: $logoutOptions) {
            .init(title: Text("Settings"), message: Text("Available Options"), buttons: [
                .default(Text(Variables.isDarkMode ? "Toggle Light Mode" : "Toggle Dark Mode"), action: {
                    Variables.isDarkMode.toggle()
                    print("dark mode : \(Variables.isDarkMode)")
                }),
                
                .destructive(Text("Log Out"), action: {
                    print("sign-out")
                    viewmodel.signOut()
                }),
                
                .cancel()
            ])
        }
        .fullScreenCover(isPresented: $viewmodel.isLoggedOut, onDismiss: nil) {
            LoginScreen(didLogin: {
                self.viewmodel.isLoggedOut = false
                self.viewmodel.fetchCurrentUser()
            })
        }
    }

    var body: some View {
        NavigationView{
            
            VStack {
//                Text("current user : \(viewmodel.msg)")
                
                NavBar
                
                ScrollView {
                        ForEach(0..<2, id: \.self) { num in
                            NavigationLink {
                                ChatView(displayedText: "Example", showKey1: false, showKey2: false, encrypted: false)
                            } label: {
                                messageCell()
                            }
                            Divider()
                                .padding(.vertical,8)
                        }
                        
                    }
                    .padding(.horizontal)
                
                
                
                
            }
            //new message button
            .overlay(Button {
                print("new message")
            } label : {
                HStack {
                    Spacer()
                    Text("+ New Message")
                    Spacer()
                }
                .foregroundColor(Color(.white))
                
                .padding(.vertical)
                    .background(Color(.systemGreen))
                    .cornerRadius(34)
                    .padding(.horizontal)
                
            }, alignment: .bottom)
            .navigationBarHidden(true)
            
        }
        
    }
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
