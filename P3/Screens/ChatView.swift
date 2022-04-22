//
//  ChatView.swift
//  P3
//
//  Created by Silas White on 4/7/22.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        ScrollView {
            ChatCell(text: "yo what up", sent: true)
            ChatCell(text: "yo what up", sent: false)
            ChatCell(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris a suscipit tortor. Quisque eu mauris faucibus, tristique dolor a, feugiat ex. Sed volutpat justo sem, id lobortis ante hendrerit vitae. Pellentesque massa justo, molestie accumsan pulvinar feugiat, pretium eu nunc. Nunc feugiat dui ac felis facilisis molestie. Sed pellentesque nisi vel turpis iaculis imperdiet. Mauris facilisis sapien at nibh sagittis suscipit. Morbi at odio enim. Phasellus nec urna vitae elit congue posuere vitae a risus. Phasellus ac augue pharetra, suscipit enim sit amet, aliquam nulla. ", sent: false)
            ChatCell(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris a suscipit tortor. Quisque eu mauris faucibus, tristique dolor a, feugiat ex. Sed volutpat justo sem, id lobortis ante hendrerit vitae. Pellentesque massa justo, molestie accumsan pulvinar feugiat, pretium eu nunc. Nunc feugiat dui ac felis facilisis molestie. Sed pellentesque nisi vel turpis iaculis imperdiet. Mauris facilisis sapien at nibh sagittis suscipit. Morbi at odio enim. Phasellus nec urna vitae elit congue posuere vitae a risus. Phasellus ac augue pharetra, suscipit enim sit amet, aliquam nulla. ", sent: true)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
