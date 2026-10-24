public import FeatherApplication
public import UserModule

extension Role.Edit.UseCase {
    public enum Error: UseCaseError {
        case notFound
    }
}
