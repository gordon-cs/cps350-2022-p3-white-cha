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
                        
                        ForEach(0..<69, id: \.self) { num in
                            messageCell()
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
