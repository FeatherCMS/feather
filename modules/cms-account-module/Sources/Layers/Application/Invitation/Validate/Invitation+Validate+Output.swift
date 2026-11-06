public import AccountModule
public import FeatherApplication

public import struct Foundation.Date

extension Invitation.Validate {
    public struct Output: DTO {
        public let id: String
        public let userId: String
        public let email: String
        public let token: String
        public let roleIDs: [String]
        public let expiresAt: Date
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            userId: String,
            email: String,
            token: String,
            roleIDs: [String],
            expiresAt: Date,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.userId = userId
            self.email = email
            self.token = token
            self.roleIDs = roleIDs
            self.expiresAt = expiresAt
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
