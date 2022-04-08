//
//  messageCell.swift
//  P3
//
//  Created by Amos Cha on 4/4/22.
//

import SwiftUI

struct messageCell: View {
    @State var seen = false
    
    var body: some View {
        Spacer()
        HStack {
            
            Image(systemName: "person.fill")
                .font(.system(size:30))
                .foregroundColor(Color(.gray))
                .padding(4)
                .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray, lineWidth: 2))
                
            VStack(alignment: .leading) {
                Text("send_user")
                Text("last_message")
            }
            Spacer()
            
            Text("last_msg_time")
        }
    }
}

struct messageCell_Previews: PreviewProvider {
    static var previews: some View {
        messageCell()
    }
}
