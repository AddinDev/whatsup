//
//  ChatsView.swift
//  whatsup
//
//  Created by addjn on 16/10/20.
//

import SwiftUI
import Firebase

struct ChatsView: View {
    @ObservedObject var networking = Networking()
    @Environment(\.presentationMode) var presentationMode
    let db = Firestore.firestore()
    @State var isAddContact = false
    @State var phone = ""
    @State var result = ""
    var body: some View {
        NavigationView {
            VStack {
                //                TextField("phone", text: $phone)
                //                    .padding(8)
                //                    .background(Color(.systemGray6))
                //                    .cornerRadius(8)
                //                    .padding(.horizontal, 10)
                ZStack {
                    List(networking.partners) { user in
//                        NavigationLink(destination: ChatView(user: user)) {
                            ChatList(user: user)
                        }
//                    }
                    .listStyle(PlainListStyle())
                    
                    NewChatButton(isAddContact: self.$isAddContact)
                    
                }
            }
            .navigationBarItems(leading: Button("Check"){ self.networking.getDataPartner()})
            .navigationTitle("Chats")
            .sheet(isPresented: $isAddContact) {
                NavigationView {
                    VStack {
                        Form {
                            Section(header: Text("phone")) {
                                
                                HStack {
                                    TextField("phone number", text: $phone)
                                        .keyboardType(.numberPad)
                                    Button("Check") {
                                        self.check()
                                    }
                                }
                                
                            }
                            if self.result == "ada co" {
                                Text("\(self.result)")
                                    .foregroundColor(.green)
                            } else if self.result == "gada co" {
                                Text("\(self.result)")
                                    .foregroundColor(.red)
                            }
                        }
                        Spacer()
                    }
                    .navigationBarItems(trailing: Button("Save") {
                        self.networking.savePartner(phone: self.phone)
                        self.phone = ""
                        self.result = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        self.isAddContact = false
                        
                    })
                }
                
            }
        }
    }
    
    func check() {
        db.collection("User").whereField("phone", isEqualTo: self.phone).getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if querySnapshot!.documents.count > 0 {
                    self.result = "ada co"
                } else {
                    self.result = "gada co"
                }
            }
        }
    }
        
}

struct NewChatButton: View {
    @Binding var isAddContact: Bool
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.isAddContact = true
                    
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color(.systemGray6))
                            .padding()
                        Image(systemName: "message.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                
            }
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
