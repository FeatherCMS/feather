import FeatherDomain

import struct Foundation.Date

public struct AuthEmail: Model {
    public let id: String
    public var identityId: String
    public var email: String
    public let createdAt: Date
    public var updatedAt: Date

    package init(
        id: String,
        identityId: String,
        email: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.identityId = identityId
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
