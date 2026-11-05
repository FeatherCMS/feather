public import FeatherApplication
public import SystemModule

extension Permission.Edit {
    public enum Error: UseCaseError {
        case notFound
    }
}
