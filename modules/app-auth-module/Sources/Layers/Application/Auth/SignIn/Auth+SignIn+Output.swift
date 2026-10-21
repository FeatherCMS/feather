public import AuthDomain
public import AuthModule
public import FeatherApplication
public import UserDomain
public import UserModule

extension AuthModule.Auth.SignIn {
    public struct Output: DTO, Sendable {
        public let user: Identity.Model
        public let session: Session.Model
        public let roles: [String]
        public let permissions: [String]

        package init(
            user: Identity.Model,
            session: Session.Model,
            roles: [String],
            permissions: [String]
        ) {
            self.user = user
            self.session = session
            self.roles = roles
            self.permissions = permissions
        }
    }
}
