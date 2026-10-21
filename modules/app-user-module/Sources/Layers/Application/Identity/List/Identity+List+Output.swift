public import FeatherApplication
public import UserDomain
public import UserModule

extension Identity.List {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let name: String
            public let status: Identity.Model.Status
            public let roles: [String]

            package init(
                id: String,
                name: String,
                status: Identity.Model.Status,
                roles: [String]
            ) {
                self.id = id
                self.name = name
                self.status = status
                self.roles = roles
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
