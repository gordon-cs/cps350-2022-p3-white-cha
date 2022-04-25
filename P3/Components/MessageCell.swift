//
//  messageCell.swift
//  P3
//
//  Created by Amos Cha on 4/8/22.
//

import SwiftUI




struct messageCell: View {
    let otherUser: User?
    @State var seen = false
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: otherUser?.imgURL ?? "")) { image in
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
            
            
            VStack (alignment: .leading) {
                Text(otherUser?.email ?? "")
                    .font(.system(size:20))
                    .foregroundColor(Color("text"))
                
                Text("last message")
                    .foregroundColor(Color(.lightGray))
            }
            Spacer()
            Text("20 min")
                .foregroundColor(Color(.lightGray))
            
        }
        .padding(2)
    }
}

