//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

import Foundation

public struct UserTokenObject: Codable {

    public let id: UUID
    public let value: String
    public let userId: UUID

    public init(id: UUID, value: String, userId: UUID) {
        self.id = id
        self.value = value
        self.userId = userId
    }
}
