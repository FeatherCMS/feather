public import AuthModule
public import FeatherApplication

extension Email.List {
    public struct Output: DTO, Sendable {
        public struct Item: Sendable {
            public let id: String
            public let identityId: String
            public let email: String

            package init(id: String, identityId: String, email: String) {
                self.id = id
                self.identityId = identityId
                self.email = email
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
