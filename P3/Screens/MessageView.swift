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
    
    init() {
//        login()
        fetchCurrentUser()
    }
//    /*
//     * temporary hard coded login
//     */
//    private func login() {
//        firebaseManager.shared.auth.signIn(withEmail: "test@test.com", password: "testtest") {
//            result, e in
//            if let e = e {
//                print("Failed to log into user:", e)
//                return
//            }
//            print("logged into user: \(result?.user.uid ?? "" ) ")
//        }
//    }
//
    
    private func fetchCurrentUser() {

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
                        
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let imgURL = data["imgURL"] as? String ?? ""
            self.currentUser = CurrentUser(uid: uid, email: email, imgURL: imgURL)
        }
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
                
                .destructive(Text("Sign Out"), action: {
                    print("sign-out")
                }),
                
                .cancel()
            ])
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
