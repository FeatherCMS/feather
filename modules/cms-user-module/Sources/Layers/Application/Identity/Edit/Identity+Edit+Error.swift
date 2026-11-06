public import FeatherApplication
public import UserModule

extension Identity.Edit {
    public enum Error: UseCaseError {
        case identityNotFound
        case roleNotFound
    }
}
