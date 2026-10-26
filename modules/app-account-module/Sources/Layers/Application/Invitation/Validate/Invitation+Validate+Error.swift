public import AccountModule
public import FeatherApplication

extension Invitation.Validate {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
