//
//  NewMessengerConstant.swift
//  Messenger
//
//  Created by LinhMAC on 19/02/2024.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    var users: [String: User]
}

// MARK: - User
struct User: Codable {
    var avatar, email, id, name: String?
    var phoneNumber: String?
    enum CodingKeys: CodingKey {
        case avatar
        case email
        case id
        case name
        case phoneNumber
    }
    init(avatar: String? = nil, email: String? = nil, id: String? = nil, name: String? = nil, phoneNumber: String? = nil) {
        self.avatar = avatar
        self.email = email
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
