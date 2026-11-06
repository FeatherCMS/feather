public import FeatherApplication
public import UserModule

extension Identity.Add {
    public enum Error: UseCaseError {
        case roleNotFound
    }
}
