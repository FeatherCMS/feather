public import AccountModule
public import FeatherApplication

extension Account.Add {
    public struct Output: DTO {
        public let userId: String
        public let email: String

        public init(
            userId: String,
            email: String
        ) {
            self.userId = userId
            self.email = email
        }
    }
}
