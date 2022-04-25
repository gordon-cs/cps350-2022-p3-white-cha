//
//  ChatView.swift
//  P3
//
//  Created by Silas White on 4/7/22.
//
import SwiftUI
import FirebaseDatabase


struct ChatView: View {
    let otherUser: User?
    @State private var message: String = ""
    @State private var messageArr: Array<Dictionary<String, String>> = [[:]]
    var ref: DatabaseReference = firebaseManager.shared.RTDB.child("users").child(firebaseManager.shared.auth.currentUser!.uid).child("messages")
    
    func handleSend (uid: String) {
        messageArr.insert(["sent": firebaseManager.shared.auth.currentUser!.uid, "message": message], at: 0)
        ref.child(uid).setValue(messageArr)
        firebaseManager.shared.RTDB.child("users").child(uid).child("messages").child(firebaseManager.shared.auth.currentUser!.uid).setValue(messageArr)
        message = ""
    }
    
    func observeData(uid: String) {
        ref.child(uid).observe(.value, with: {(snapshot) in
            messageArr = snapshot.value as! Array<Dictionary<String, String>>
        })
    }
    var body: some View {
//        var refHandle = firebaseManager.shared.RTDB.child("users").child(firebaseManager.shared.auth.currentUser!.uid).child(otherUser!.uid).observe(DataEventType.value, with: { snapshot in
//            print(snapshot)
//          })
        VStack {
            ScrollView {
                // Must pass items newest first. If the array is
                // sorted from oldest to newest, index from last message
                LazyVStack {

                    ForEach(messageArr, id: \.self) { chats in
                        ChatCell(text: chats["message"] ?? "", sent: firebaseManager.shared.auth.currentUser!.uid == chats["sent"]).flippedUpsideDown()
                    }

                }
                .padding(.top,5)
            }
            .flippedUpsideDown()
            
            HStack (alignment: .bottom) {
                VStack {
                    Button {
                        // TODO
                    } label: {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 28))
                            .foregroundColor(Color(.white))
                            .padding(.horizontal, 5)
                    }
                }
                
                ExpandingTextView(text: $message)
                    .padding(.top, 5)
                    .cornerRadius(15)
                    .offset(y: 5)
                VStack {
                    Button {
                        handleSend(uid: otherUser!.uid)
                    } label: {
                        Image("send")
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .foregroundColor(Color(.white))
                            .padding(.horizontal, 5)
                    }
                }
                
            }
            .background(Color( "primary" ))
            .ignoresSafeArea()
            
        }
        .navigationTitle(otherUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            observeData(uid: otherUser!.uid)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
            .preferredColorScheme(Variables.isDarkMode ? .dark : .light)
        
    }
}
