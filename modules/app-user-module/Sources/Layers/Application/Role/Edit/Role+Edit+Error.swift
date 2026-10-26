public import FeatherApplication
public import UserModule

extension Role.Edit {
    public enum Error: UseCaseError {
        case notFound
    }
}
