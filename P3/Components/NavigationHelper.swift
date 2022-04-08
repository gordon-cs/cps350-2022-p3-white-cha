//
//  NavigationHelper.swift
//  P3
//
//  Created by Amos Cha on 4/8/22.
//

import Foundation
import SwiftUI


/// Navigate to a new view.
/// - Parameters:
///   - view: View to navigate to.
///   - binding: Only navigates when this condition is `true`.
extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
