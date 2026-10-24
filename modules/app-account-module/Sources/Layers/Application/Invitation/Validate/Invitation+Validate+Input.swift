public import AccountModule
public import FeatherApplication

extension Invitation.Validate {
    public struct Input: DTO {
        public let token: String

        public init(token: String) {
            self.token = token
        }
    }
}
