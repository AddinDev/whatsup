//
//  ContentView.swift
//  whatsup
//
//  Created by addjn on 16/10/20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var isLogged = UserDefaults.standard.bool(forKey: "isLogged")
    var body: some View {
        ZStack {
            IntroView(isLogged: self.$isLogged).opacity(isLogged ? 0 : 1)
            MainContainer(isLogged: self.$isLogged).opacity(isLogged ? 1 : 0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
