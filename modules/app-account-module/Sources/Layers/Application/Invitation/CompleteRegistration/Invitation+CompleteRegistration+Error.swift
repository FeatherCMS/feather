public import AccountModule
public import FeatherApplication

extension Invitation.CompleteRegistration {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
