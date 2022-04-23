//
//  ChatView.swift
//  P3
//
//  Created by Silas White on 4/7/22.
//

import SwiftUI

struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    let textDidChange: (UITextView) -> Void
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.delegate = context.coordinator
        view.font = UIFont.systemFont(ofSize: 20)
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, textDidChange: textDidChange)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: (UITextView) -> Void
        
        init(text: Binding<String>, textDidChange: @escaping (UITextView) -> Void) {
            self._text = text
            self.textDidChange = textDidChange
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
    }
}

struct ExpandingTextView: View {
    @Binding var text: String
    let minHeight: CGFloat = 50
    @State private var textViewHeight: CGFloat?
    
    var body: some View {
        WrappedTextView(text: $text, textDidChange: self.textDidChange)
            .frame(height: textViewHeight ?? minHeight)
            .cornerRadius(15)
    }
    
    private func textDidChange(_ textView: UITextView) {
        self.textViewHeight = max(textView.contentSize.height, minHeight)
    }
}

struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View{
    func flippedUpsideDown() -> some View {
        self.modifier(FlippedUpsideDown())
    }
}



struct ChatView: View {
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
            }
            .flippedUpsideDown()
            HStack (alignment: .bottom) {
                VStack {
                    Button {
                        // TODO
                    } label: {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 30))
                            .foregroundColor(Color(.white))
                            .padding(.horizontal, 5)
                    }
                }
                
                ExpandingTextView(text: $message)
                    .padding(.top, 8)
                    .cornerRadius(15)
                    .offset(y: 5)
                VStack {
                    Button {
                        handleSend()
                    } label: {
                        Image("send")
                            .renderingMode(.template)
                            .font(.system(size: 30))
                            .foregroundColor(Color(.white))
                            .padding(.horizontal, 5)
                    }
                }
                
            }
            .background(Color("secondary"))
            .ignoresSafeArea()
            
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
