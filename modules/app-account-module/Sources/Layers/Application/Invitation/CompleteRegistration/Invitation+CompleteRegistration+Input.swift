public import AccountModule
public import FeatherApplication

extension Invitation.CompleteRegistration {
    public struct Input: DTO {
        public let token: String
        public let password: String

        public init(token: String, password: String) {
            self.token = token
            self.password = password
        }
    }
}
