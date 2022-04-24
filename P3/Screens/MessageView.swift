//
//  MessageView.swift
//  P3
//
//  Created by Amos Cha on 4/4/22.
//

import SwiftUI


struct MessageView: View {
    
    @ObservedObject private var viewmodel = MessageViewmodel()
    @State var logoutOptions = false
    @State var showContacts = false
    
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
    @ObservedObject var vm = createMessageVM()
    @State var shouldNavigateToChatView = false
    
    
    var body: some View {
        
        NavigationView{
            
            VStack {
//                Text("current user : \(viewmodel.msg)")
                
                NavBar
                
                ScrollView {
                    ForEach(vm.users) { user in

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
            .preferredColorScheme(Variables.isDarkMode ? .dark : .light)
    }
}
