public import FeatherApplication
public import SystemModule

extension Variable.Edit.UseCase {
    public enum Error: UseCaseError {
        case notFound
    }
}
