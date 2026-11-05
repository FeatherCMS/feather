public import AuthModule
public import FeatherApplication

extension MagicLink.Edit {
    public enum Error: FeatherApplication.UseCaseError {
        case notFound(id: String)
    }
}
