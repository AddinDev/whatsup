//
//  LoginView.swift
//  whatsup
//
//  Created by addjn on 16/10/20.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isLogged: Bool
    @State var email = ""
    @State var password = ""
    var body: some View {
        VStack {
            TextField("email", text: $email)
                .padding()
                .background(Color(.systemGray6))
            SecureField("password", text: $password)
                .padding()
                .background(Color(.systemGray6))
            Button("Login") {
                Auth.auth().signIn(withEmail: self.email, password: self.password) { (resullt, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("logged")
                        self.presentationMode.wrappedValue.dismiss()
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                        
                        withAnimation {
                        self.isLogged = true
                            UserDefaults.standard.set(self.isLogged, forKey: "isLogged")

                        }
                    }
                }
            }
        }
    }
}


