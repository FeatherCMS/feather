public import AccountModule

extension AccountModule.Event.Seed {
    public struct Definition: Sendable, Hashable, Codable {
        public let email: String
        public let password: String
        public let roleKeys: [String]

        public init(
            email: String,
            password: String,
            roleKeys: [String] = []
        ) {
            self.email = email
            self.password = password
            self.roleKeys = roleKeys
        }
    }
}
