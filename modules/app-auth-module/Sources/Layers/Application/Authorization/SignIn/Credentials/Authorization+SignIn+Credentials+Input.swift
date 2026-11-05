public import AuthModule
public import FeatherApplication

extension AuthModule.Authorization.SignIn.Credentials {
    public struct Input: DTO {
        public let email: String
        public let password: String
        public let isPersistent: Bool

        public init(email: String, password: String, isPersistent: Bool) {
            self.email = email
            self.password = password
            self.isPersistent = isPersistent
        }
    }
}
