public import AuthModule
public import FeatherApplication
public import UserApplication
public import UserModule

extension AuthModule.Authorization.CurrentUser {
    public struct Output: DTO, Sendable {
        public let user: UserModule.Identity.Detail.Output
        public let roles: [String]
        public let permissions: [String]

        public init(
            user: UserModule.Identity.Detail.Output,
            roles: [String],
            permissions: [String]
        ) {
            self.user = user
            self.roles = roles
            self.permissions = permissions
        }
    }
}
