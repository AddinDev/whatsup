//
//  RegisterView.swift
//  whatsup
//
//  Created by addjn on 16/10/20.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isLogged: Bool
    let db = Firestore.firestore()
    let imageDefault = "https://firebasestorage.googleapis.com/v0/b/whatsup-27adf.appspot.com/o/default%2Fdefaultpic.jpg?alt=media&token=3e244d8f-f9c2-4680-9c0a-ea17a450a672"
    @State var name = ""
    @State var phone = ""
    @State var email = ""
    @State var password = ""
    var body: some View {
        VStack {
            TextField("name", text: $name)
                .padding()
                .background(Color(.systemGray6))
            TextField("phone", text: $phone)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
            TextField("email", text: $email)
                .padding()
                .background(Color(.systemGray6))
            SecureField("password", text: $password)
                .padding()
                .background(Color(.systemGray6))
            Button("Register") {
                Auth.auth().createUser(withEmail: self.email, password: self.password) { (resullt, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("registered")
                        
                        db.collection("User").document(Auth.auth().currentUser!.uid).setData([
                            "name": self.name,
                            "phone": self.phone,
                            "email": self.email,
                            "imageUrl": self.imageDefault,
                            "status": "",
                            "statusUrl": "",
                            "statusTime": "",
                            "uid": Auth.auth().currentUser!.uid
                            
                        ])
                        
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

