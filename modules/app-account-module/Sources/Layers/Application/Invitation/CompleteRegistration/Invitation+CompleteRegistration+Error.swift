public import FeatherApplication
public import AccountModule

extension Invitation.CompleteRegistration.UseCase {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
