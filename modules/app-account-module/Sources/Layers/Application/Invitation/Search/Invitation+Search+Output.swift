public import AccountModule
public import FeatherApplication

public import struct Foundation.Date

extension Invitation.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let userId: String
            public let email: String
            public let token: String
            public let roleIDs: [String]
            public let expiresAt: Date
            public let createdAt: Date
            public let updatedAt: Date

            package init(
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

        public let items: [Item]
        public let total: Int

        public init(items: [Item], total: Int) {
            self.items = items
            self.total = total
        }
    }
}
