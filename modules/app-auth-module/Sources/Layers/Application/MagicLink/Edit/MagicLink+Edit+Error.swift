public import AuthModule
public import FeatherApplication

extension MagicLink.Edit.UseCase {
    public enum Error: FeatherApplication.UseCaseError {
        case notFound(id: String)
    }
}
