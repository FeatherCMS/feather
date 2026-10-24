public import AuthModule
public import FeatherApplication

extension MagicLink.Request.UseCase {
    public enum Error: FeatherApplication.UseCaseError {
        case mailFromNotConfigured

        public var message: String {
            switch self {
            case .mailFromNotConfigured:
                "System mail from address is not configured. Configure the system-settings-mail-from-address variable in System → Variables."
            }
        }
    }
}
