public import AccountModule
public import FeatherApplication

extension Invitation.Resend {
    public enum Error: UseCaseError {
        case invitationNotFound
        case mailFromNotConfigured

        public var message: String {
            switch self {
            case .invitationNotFound:
                "Invitation not found."
            case .mailFromNotConfigured:
                "System mail from address is not configured. Configure the system-settings-mail-from-address variable in System → Variables."
            }
        }
    }
}
