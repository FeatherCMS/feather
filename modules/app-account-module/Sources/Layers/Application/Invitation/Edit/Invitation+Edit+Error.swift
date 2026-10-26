public import FeatherApplication
public import AccountModule

extension Invitation.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
