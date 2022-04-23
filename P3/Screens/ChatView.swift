//
//  ChatView.swift
//  P3
//
//  Created by Silas White on 4/7/22.
//

import SwiftUI

extension View {
    func hasScrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}

struct ChatView: View {
    @State private var message: String = ""
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ChatCell(text: "yo what up", sent: true)
                    ChatCell(text: "yo what up", sent: false)
                    ChatCell(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris a suscipit tortor. Quisque eu mauris faucibus, tristique dolor a, feugiat ex. Sed volutpat justo sem, id lobortis ante hendrerit vitae. Pellentesque massa justo, molestie accumsan pulvinar feugiat, pretium eu nunc. Nunc feugiat dui ac felis facilisis molestie. Sed pellentesque nisi vel turpis iaculis imperdiet. Mauris facilisis sapien at nibh sagittis suscipit. Morbi at odio enim. Phasellus nec urna vitae elit congue posuere vitae a risus. Phasellus ac augue pharetra, suscipit enim sit amet, aliquam nulla. ", sent: false)
                    ChatCell(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris a suscipit tortor. Quisque eu mauris faucibus, tristique dolor a, feugiat ex. Sed volutpat justo sem, id lobortis ante hendrerit vitae. Pellentesque massa justo, molestie accumsan pulvinar feugiat, pretium eu nunc. Nunc feugiat dui ac felis facilisis molestie. Sed pellentesque nisi vel turpis iaculis imperdiet. Mauris facilisis sapien at nibh sagittis suscipit. Morbi at odio enim. Phasellus nec urna vitae elit congue posuere vitae a risus. Phasellus ac augue pharetra, suscipit enim sit amet, aliquam nulla. ", sent: true)
                }
            }
            VStack {
                List {
                    TextEditor(text: $message)
                        .padding(.all, 0)
                }
                .hasScrollEnabled(false)
                .padding(.all, 0)
                
            }
            .frame(idealHeight: 50, alignment: .bottom)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
