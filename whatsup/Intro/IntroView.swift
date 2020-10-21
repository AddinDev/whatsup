//
//  IntroView.swift
//  whatsup
//
//  Created by addjn on 16/10/20.
//

import SwiftUI

struct IntroView: View {
    @Binding var isLogged: Bool
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("login", destination: LoginView(isLogged: self.$isLogged))
                NavigationLink("register", destination: RegisterView(isLogged: self.$isLogged))
            }
            .navigationBarHidden(true)
        }
    }
}


