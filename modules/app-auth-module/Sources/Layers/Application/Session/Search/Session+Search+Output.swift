public import AuthModule
public import FeatherApplication
public import struct Foundation.Date

extension Session.Search {
    public struct Output: DTO, Sendable {
        public struct Item: Sendable {
            public let id: String
            public let authenticationType: String
            public let authenticationReference: String
            public let expiresAt: Date
            public let isPersistent: Bool
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                id: String,
                authenticationType: String,
                authenticationReference: String,
                expiresAt: Date,
                isPersistent: Bool,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.authenticationType = authenticationType
                self.authenticationReference = authenticationReference
                self.expiresAt = expiresAt
                self.isPersistent = isPersistent
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
