public import AuthModule
public import FeatherApplication

public import struct Foundation.Date

extension Credential.Search {
    public struct Output: DTO, Sendable {
        public struct Item: Sendable {
            public let id: String
            public let userId: String
            public let identityName: String
            public let email: String
            public let createdAt: Date
            public let updatedAt: Date

            public init(
                id: String,
                userId: String,
                identityName: String,
                email: String,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.userId = userId
                self.identityName = identityName
                self.email = email
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
