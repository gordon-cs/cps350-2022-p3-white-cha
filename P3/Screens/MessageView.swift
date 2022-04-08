//
//  MessageView.swift
//  P3
//
//  Created by Amos Cha on 4/4/22.
//

import SwiftUI


struct MessageView: View {
    var body: some View {
        NavigationView{
            VStack {
                //customizable nav bar
                navBar()
                ScrollView {
                        ForEach(0..<1, id: \.self) { num in
                            NavigationLink {
                                ChatView(displayedText: "Example", showKey1: false, showKey2: false, encrypted: false)
                            } label: {
                                messageCell()
                            }
                        }
                    }
                    .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
