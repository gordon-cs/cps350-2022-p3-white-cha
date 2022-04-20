//
//  ChatCell.swift
//  P3
//
//  Created by Silas White on 4/20/22.
//

import SwiftUI

struct ChatCell: View {
    var text: String
    var bubbleType: String
    var body: some View {
        ZStack {
            Text(text)
                .padding(.horizontal)
                .padding(.vertical, 5.0)
                .offset(x: -2)
                .fixedSize(horizontal: false, vertical: true)
                .background(
                Image(bubbleType)
                    .resizable(capInsets: EdgeInsets(top: 17, leading: 21, bottom: 17, trailing: 21), resizingMode: .stretch)
                    .renderingMode(.template)
                    .foregroundColor(Color(bubbleType))
                )
        }
    }
}

struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(text: "crazyaslkjdfhlkasjhdflkjahsldkjfhlakjshdflkjhaslkjdfhlkajshdflkjahslkjdfhlkajshdlkfjhalskjdhflkjash", bubbleType: "received")
    }
}
