public import FeatherApplication
public import AccountModule

extension Invitation.Validate {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
