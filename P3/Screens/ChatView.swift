//
//  ChatView.swift
//  P3
//
//  Created by Silas White on 4/7/22.
//

import SwiftUI


struct ChatView: View {
    let otherUser: CurrentUser?
    @State private var message: String = ""
    
    func handleSend () {
        // TODO: HANDLE FIREBASE SEND
        message = ""
    }
    var body: some View {
        VStack {
            ScrollView {
                // Must pass items newest first. If the array is
                // sorted from oldest to newest, index from last message
                LazyVStack {
                    ChatCell(text: "yo what up", sent: true)
                        .flippedUpsideDown()
                    ChatCell(text: "yo what up", sent: false)
                        .flippedUpsideDown()
                    ChatCell(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris a suscipit tortor. Quisque eu mauris faucibus, tristique dolor a, feugiat ex. Sed volutpat justo sem, id lobortis ante hendrerit vitae. Pellentesque massa justo, molestie accumsan pulvinar feugiat, pretium eu nunc. Nunc feugiat dui ac felis facilisis molestie. Sed pellentesque nisi vel turpis iaculis imperdiet. Mauris facilisis sapien at nibh sagittis suscipit. Morbi at odio enim. Phasellus nec urna vitae elit congue posuere vitae a risus. Phasellus ac augue pharetra, suscipit enim sit amet, aliquam nulla. ", sent: false)
                        .flippedUpsideDown()
                    ChatCell(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris a suscipit tortor. Quisque eu mauris faucibus, tristique dolor a, feugiat ex. Sed volutpat justo sem, id lobortis ante hendrerit vitae. Pellentesque massa justo, molestie accumsan pulvinar feugiat, pretium eu nunc. Nunc feugiat dui ac felis facilisis molestie. Sed pellentesque nisi vel turpis iaculis imperdiet. Mauris facilisis sapien at nibh sagittis suscipit. Morbi at odio enim. Phasellus nec urna vitae elit congue posuere vitae a risus. Phasellus ac augue pharetra, suscipit enim sit amet, aliquam nulla. ", sent: true)
                        .flippedUpsideDown()
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
                        handleSend()
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
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
            .preferredColorScheme(Variables.isDarkMode ? .dark : .light)

    }
}
