public import UserModule

extension Identity.Event.Seed {
    public struct Definition: Sendable, Hashable, Codable {
        public let id: String
        public let name: String
        public let status: Status
        public let isRoot: Bool
        public let roleIDs: [String]

        public init(
            id: String,
            name: String = "User",
            status: Status = .active,
            isRoot: Bool = false,
            roleIDs: [String] = []
        ) {
            self.id = id
            self.name = name
            self.status = status
            self.isRoot = isRoot
            self.roleIDs = roleIDs
        }
    }
}
