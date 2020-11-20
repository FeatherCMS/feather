//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

import Foundation

public struct UserObject: Codable {

    public let id: UUID
    public let email: String

    public init(id: UUID, email: String) {
        self.id = id
        self.email = email
    }
}
