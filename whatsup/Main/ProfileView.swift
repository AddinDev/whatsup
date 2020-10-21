//
//  ProfileView.swift
//  whatsup
//
//  Created by addjn on 16/10/20.
//

import SwiftUI
import Firebase
import URLImage

struct ProfileView: View {
    var user: User
    let db = Firestore.firestore()
    let defaultImage = "https://firebasestorage.googleapis.com/v0/b/whatsup-27adf.appspot.com/o/default%2Fdefaultpic.jpg?alt=media&token=3e244d8f-f9c2-4680-9c0a-ea17a450a672"
    @Environment(\.presentationMode) var presentationMode
    @State var image: Image?
    @State var inputImage: UIImage?
    @Binding var isLogged: Bool
    @Binding var name: String
    @Binding var email: String
    @Binding var phone: String
    @Binding var selected: Int
    @State var showImagePicker = false
    @State var isDelete = false
    var body: some View {
        ZStack {
            
            Color(.systemGray6)
            
            VStack {
                
                if image != nil {
                    image?
                        .resizable()
                        .frame(width: 120, height: 120)
                        .cornerRadius(100)
                        .padding(.top, 30)
                        .padding(.bottom, 15)
                } else {
                    Button(action: {
                        self.showImagePicker = true
                    }) {
                        URLImage(URL(string: user.imageUrl) ?? URL(string: defaultImage)! ) { proxy in
                            proxy.image
                                .resizable()
                        }
                        .frame(width: 120, height: 120)
                        .cornerRadius(100)
                        .padding(.top, 30)
                        .padding(.bottom, 15)
                        
                        //                        Image("defaultpic")
                        //                            .resizable()
                        //                            .frame(width: 120, height: 120)
                        //                            .cornerRadius(100)
                        //                            .padding(.top, 30)
                        //                            .padding(.bottom, 15)
                    }
                }
                
                Form {
                    Section(header: Text("name")) {
                        HStack {
                            TextField("\(user.name)", text: $name)
                        }
                    }
                    Section(header: Text("email")) {
                        HStack {
                            TextField("\(user.email)", text: $email)
                        }
                    }
                    Section(header: Text("phone")) {
                        HStack {
                            TextField("\(user.phone)", text: $phone)
                                .keyboardType(.numberPad)
                        }
                    }
                }
                
                Button("Delete Account") {
                    self.isDelete = true
                    
                }.foregroundColor(.red)
                
            }
        }
        .alert(isPresented: $isDelete, content: {
            Alert(title: Text("Confirmation"), message: Text("Are you sure you wanna delete this account?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Yes")) { self.deleteAccount() })
        })
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Save") {self.saveData()})
        .sheet(isPresented: $showImagePicker, onDismiss: saveImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func saveImage() {
        
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        guard let imageData = inputImage.jpegData(compressionQuality: 0.3) else { return }
        
        let storageRef = Storage.storage().reference(forURL: "gs://whatsup-27adf.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(Auth.auth().currentUser!.uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            storageProfileRef.downloadURL { (url, error) in
                if let imageUrl = url?.absoluteString {
                    print(imageUrl)
                    db.collection("User").document(Auth.auth().currentUser!.uid).updateData(["imageUrl": imageUrl]) { error in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }
                }
            }
        }
        
    }
    
    func saveData() {
        if self.name == "" && self.phone == "" {
            print("wtf")
        }
        else if self.name != "" && self.phone != "" {
            db.collection("User").document(Auth.auth().currentUser!.uid).updateData(["name": self.name, "phone": self.phone]) { error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.name = ""
                    self.phone = ""
                }
            }
        }
        else if self.name != "" {
            db.collection("User").document(Auth.auth().currentUser!.uid).updateData(["name": self.name]) { error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.name = ""
                }
            }
        } else if self.phone != "" {
            db.collection("User").document(Auth.auth().currentUser!.uid).updateData(["phone": self.phone]) { error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.phone = ""
                }
            }
        }
        
    }
    
    func deleteAccount() {
        db.collection("User").document(Auth.auth().currentUser!.uid).delete { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                Auth.auth().currentUser?.delete(completion: { (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                        withAnimation {
                            self.isLogged = false
                        }
                        self.selected = 0
                    }
                })
            }
        }
    }
}



