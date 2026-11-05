public import AccountModule
public import FeatherApplication

extension Invitation.Add {
    public enum Error: UseCaseError {
        case roleNotFound(String)
        case mailFromNotConfigured

        public var message: String {
            switch self {
            case .roleNotFound(let roleID):
                "Role not found: \(roleID)"
            case .mailFromNotConfigured:
                "System mail from address is not configured. Configure the system-settings-mail-from-address variable in System → Variables."
            }
        }
    }
}
