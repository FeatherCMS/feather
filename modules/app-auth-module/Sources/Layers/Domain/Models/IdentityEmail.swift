import FeatherDomain

import struct Foundation.Date

public struct IdentityEmail: Model {
    public let id: String
    public var identityId: String
    public var email: String
    public var isPrimary: Bool
    public var isVerified: Bool
    public let createdAt: Date
    public var updatedAt: Date

    package init(
        id: String,
        identityId: String,
        email: String,
        isPrimary: Bool,
        isVerified: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.identityId = identityId
        self.email = email
        self.isPrimary = isPrimary
        self.isVerified = isVerified
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
