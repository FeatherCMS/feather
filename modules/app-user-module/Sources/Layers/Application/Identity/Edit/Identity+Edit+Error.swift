public import FeatherApplication
public import UserModule

extension Identity.Edit.UseCase {
    public enum Error: UseCaseError {
        case identityNotFound
        case roleNotFound
    }
}
