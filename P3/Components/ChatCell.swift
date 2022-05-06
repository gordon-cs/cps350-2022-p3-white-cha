//
//  ChatCell.swift
//  P3
//
//  Created by Silas White on 4/20/22.
//

import SwiftUI

struct ChatCell: View {
    var text: String
    var sent: Bool
    var body: some View {
        if (text != "") {
            HStack {
                if (sent) {
                    Spacer()
                }
                Text(text)
                    .padding(.horizontal)
                    .padding(.vertical, 5.0)
                    .offset(x: sent ? -2 : 1)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color("text"))
                    .background(
                        Image(sent ? "sent" : "received")
                            .resizable(capInsets: EdgeInsets(top: 17, leading: 21, bottom: 17, trailing: 21), resizingMode: .stretch)
                            .renderingMode(.template)
                            .foregroundColor(Color(sent ? "sent" : "received"))
                    )
                    .frame(maxWidth: 300, alignment: sent ? .trailing : .leading)
                    .padding(.horizontal, 5)
                if (!sent) {
                    Spacer()
                }
            }
        }
    }
}

struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(text: "crazy", sent: false)
    }
}
