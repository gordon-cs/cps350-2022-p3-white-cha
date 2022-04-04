//
//  navBar.swift
//  P3
//
//  Created by Amos Cha on 4/4/22.
//

import SwiftUI

struct navBar: View {
    var body: some View {
        HStack {
            
            //profile pic
            VStack {
                Button {
                    //change profile picture button
                } label: {
                    Image(systemName: "person.fill")
                        .font(.system(size:34))
                        .foregroundColor(Color(.gray))
                        .padding(7)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.gray, lineWidth: 2))
            
            //name & status
            
            VStack (alignment: .leading, spacing: 2) {
                Text("My_Name")
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
                //settings button
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 25))
                    .foregroundColor(Color(.gray))
            }
        
        }
        .padding()
        Divider()
    }
}


struct navBar_Previews: PreviewProvider {
    static var previews: some View {
        navBar()
    }
}
