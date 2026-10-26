public import AccountModule
public import FeatherApplication

extension Invitation.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
