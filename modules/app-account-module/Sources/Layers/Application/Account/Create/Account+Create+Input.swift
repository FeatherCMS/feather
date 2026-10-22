public import AccountModule
public import FeatherApplication

extension Account.Create {
    public struct Input: DTO {
        public let email: String
        public let password: String

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
}
