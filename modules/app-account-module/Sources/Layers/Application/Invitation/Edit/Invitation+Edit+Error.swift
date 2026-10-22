public import FeatherApplication
public import AccountModule

extension Invitation.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
