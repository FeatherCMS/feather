public import AuthModule
public import FeatherApplication

extension AuthEmail.Add {
    public struct Output: DTO, Sendable {
        public let id: String
        public let identityId: String
        public let email: String

        package init(id: String, identityId: String, email: String) {
            self.id = id
            self.identityId = identityId
            self.email = email
        }
    }
}
