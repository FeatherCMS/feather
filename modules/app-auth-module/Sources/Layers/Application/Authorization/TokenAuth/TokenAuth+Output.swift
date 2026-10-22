public import AuthModule
public import FeatherApplication

extension AuthModule.Authorization.TokenAuth {
    public struct Output: DTO, Sendable {
        public let identityId: String
        public let roles: [String]
        public let permissions: [String]
        public let isPersistent: Bool

        public init(
            identityId: String,
            roles: [String],
            permissions: [String],
            isPersistent: Bool
        ) {
            self.identityId = identityId
            self.roles = roles
            self.permissions = permissions
            self.isPersistent = isPersistent
        }
    }
}
