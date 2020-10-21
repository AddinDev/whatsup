//
//  User.swift
//  whatsup
//
//  Created by addjn on 16/10/20.
//

import Foundation

struct User: Codable, Identifiable {
    let id = UUID()
    let email: String
    let phone: String
    let name: String
    let imageUrl: String
    let status: String?
    let statusUrl: String?
    let statusTime: String?
    let uid: String
    let userChat: String
}
