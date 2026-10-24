public import FeatherApplication
public import SystemModule

extension Permission.Edit.UseCase {
    public enum Error: UseCaseError {
        case notFound
    }
}
