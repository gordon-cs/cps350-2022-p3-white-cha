//
//  MessageView.swift
//  P3
//
//  Created by Amos Cha on 4/4/22.
//
import SwiftUI
import FirebaseDatabase


struct MessageView: View {
    
    @ObservedObject private var viewmodel = MessageViewmodel()
    @State var logoutOptions = false
    @State var showContacts = false
    
    @State private var ShowImageSelect = false
    @State private var image: UIImage?
    @State private var imageURL = ""
    
    
    func saveProfilePicture(img : UIImage?) {
        if(img != nil) {
            guard let uid = firebaseManager.shared.auth.currentUser?.uid
            else { return }
            guard let imgData = img?.jpegData(compressionQuality: 0.69)
            else { return }
            let reference = firebaseManager.shared.storage.reference(withPath: uid)
            
            reference.putData(imgData, metadata: nil) { metadata, error in
                if let error = error {
                    print(error)
                    return
                }
                
                reference.downloadURL { url, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let url = url else { return }
                    imageURL = url.absoluteString
                    
                    let userData: [String: Any] = ["imgURL": url.absoluteString]
                    
                    firebaseManager.shared.firestore.collection("users")
                        .document( uid ).updateData(userData) { error in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                        }
                    
                }
            }
            
        } else {
            print("did not save profile picture")
            return
        }
        
        
    }
    
    //Custom Nav Bar
    var NavBar: some View {
        //        Text("\(viewmodel.msg)")
        
        HStack {
            //profile pic
            VStack {
                Button {
                    //change profile picture button
                    ShowImageSelect.toggle()
                } label: {
                    AsyncImage(url: URL(string: imageURL == "" ? viewmodel.currentUser?.imgURL ?? "" : imageURL)) { image in
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
                        .foregroundColor(Color("select"))
                        .frame(width: 14, height: 14)
                    Text("online")
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
//                .default(Text(Variables.isDarkMode ? "Toggle Light Mode" : "Toggle Dark Mode"), action: {
//                    Variables.isDarkMode.toggle()
//                    print("dark mode : \(Variables.isDarkMode)")
//                }),
                .default(Text("Change Profile Picture"), action: {
                    ShowImageSelect.toggle()
                }),
                
                    .destructive(Text("Log Out"), action: {
                        print("sign-out")
                        imageURL = ""
                        viewmodel.signOut()
                        contactArray.removeAll()
                        
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
    
    private var newMessage: some View {
        Button {
            print("new message")
            showContacts.toggle()
        } label : {
            HStack {
                Spacer()
                Text("+ New Message")
                Spacer()
            }
            .foregroundColor(Color(.white))
            
            .padding(.vertical)
            .background(Color("select"))
            .cornerRadius(34)
            .padding(.horizontal)
            
        }
        .fullScreenCover(isPresented: $showContacts) {
            createMessage(didSelectUser: { user in
                print(user.email)
                self.shouldNavigateToChatView.toggle()
                self.otherUser = user
            })
        }
    }
    
    @State var otherUser: CurrentUser?
    @State var shouldNavigateToChatView = false
    
    @State var contactArray: Array<CurrentUser> = []
    
    private var ref: DatabaseReference = firebaseManager.shared.RTDB.child("users")
    
    private func observeData() {
        ref.child(firebaseManager.shared.auth.currentUser!.uid).child("contacts").observe(.value, with: {(snapshot) in
            let arr = snapshot.value as? Array<String> ?? []
            contactArray.removeAll()
            for uid in arr {
                firebaseManager.shared.firestore.collection("users")
                    .document(uid).getDocument { userSnapshot, error in
                        if let error = error {
                            print("Failed to fetch user: \(error)")
                            return
                        }
                        let data = userSnapshot!.data()
                        let user = CurrentUser(data: data!)
                        contactArray.insert(user, at: 0)
                    }
            }
        })
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                
                NavBar
                if (!self.viewmodel.isLoggedOut) {
                    ScrollView {
                        ForEach(contactArray) { user in
                            
                            Button {
                                otherUser = user
                                shouldNavigateToChatView.toggle()
                            } label : {
                                messageCell(otherUser: user)
                            }
                            
                            NavigationLink("", isActive: $shouldNavigateToChatView) {
                                ChatView(otherUser: self.otherUser)
                            }
                            
                            
                            Divider()
                                .padding(.vertical,8)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom,50)
                    .onAppear{
                        observeData()
                    }
                }
                
            }
            // used for image selection
            .fullScreenCover(isPresented: $ShowImageSelect, onDismiss: {
                saveProfilePicture(img : image)
            })
            {
                //Text("test")
                ImageSelect(image: $image)
                
            }
            //new message button
            .overlay(newMessage, alignment: .bottom)
            .navigationBarHidden(true)
            
        }
        
    }
    
}



struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
