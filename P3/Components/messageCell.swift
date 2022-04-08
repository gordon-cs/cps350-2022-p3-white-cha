//
//  messageCell.swift
//  P3
//
//  Created by Amos Cha on 4/8/22.
//

import SwiftUI

struct messageCell: View {
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(Color(.gray))
                .font(.system(size: 30))
                .padding(6)
                .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(.gray), lineWidth: 2)
                )
            VStack (alignment: .leading) {
                Text("Sent name")
                    .foregroundColor(Color(.black))
                Text("last message")
                    .foregroundColor(Color(.lightGray))
            }
            Spacer()
            Text("last msg time")
                .foregroundColor(Color(.black))
            
        }
        .padding(2)
    }
}

struct messageCell_Previews: PreviewProvider {
    static var previews: some View {
        messageCell()
    }
}
