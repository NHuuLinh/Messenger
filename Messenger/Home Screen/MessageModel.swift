//
//  MessageModel.swift
//  Messenger
//
//  Created by Huu Linh Nguyen on 12/12/24.
//
import Foundation

// MARK: - Message
struct FriendList: Codable {
    let documents: [Document]?

    enum CodingKeys: String, CodingKey {
        case documents = "documents"
    }
}

// MARK: - Document
struct Document: Codable, Hashable {
    let name: String?
    let fields: Fields?
    let createTime: String?
    let updateTime: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case fields = "fields"
        case createTime = "createTime"
        case updateTime = "updateTime"
    }
}

// MARK: - Fields
struct Fields: Codable {
    let iconMessage: IconMessage?
    let typeMessage: IconMessage?
    let seen: Seen?
    let idSender: IconMessage?
    let messageImage: IconMessage?
    let idMessage: IconMessage?
    let idReceive: IconMessage?
    let sendAt: IconMessage?
    let messageContent: IconMessage?

    enum CodingKeys: String, CodingKey {
        case iconMessage = "iconMessage"
        case typeMessage = "typeMessage"
        case seen = "seen"
        case idSender = "idSender"
        case messageImage = "messageImage"
        case idMessage = "idMessage"
        case idReceive = "idReceive"
        case sendAt = "sendAt"
        case messageContent = "messageContent"
    }
}

// MARK: - IconMessage
struct IconMessage: Codable {
    let stringValue: String?

    enum CodingKeys: String, CodingKey {
        case stringValue = "stringValue"
    }
}

// MARK: - Seen
struct Seen: Codable {
    let booleanValue: Bool?

    enum CodingKeys: String, CodingKey {
        case booleanValue = "booleanValue"
    }
}
