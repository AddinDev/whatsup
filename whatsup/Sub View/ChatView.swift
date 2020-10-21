//
//  ChatView.swift
//  whatsup
//
//  Created by addjn on 20/10/20.
//

import SwiftUI

struct ChatView: View {
    var user: User
    @State var text = ""
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("type", text: $text)
                    .padding(8)
                background(Color(.systemGray6))
                    .cornerRadius(8)
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    print("send msg")
                }) {
                    Image(systemName: "arrow.up.circle")
                }
                
            }
        }
    }
}
