public import FeatherApplication
public import UserModule

extension Identity.Add.UseCase {
    public enum Error: UseCaseError {
        case roleNotFound
    }
}
