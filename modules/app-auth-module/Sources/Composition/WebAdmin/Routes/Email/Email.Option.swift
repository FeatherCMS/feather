public import AuthModule

extension Email {
    public struct Option: Sendable {
        public let id: String
        public let identityId: String
        public let email: String

        public init(id: String, identityId: String, email: String) {
            self.id = id
            self.identityId = identityId
            self.email = email
        }
    }
}
