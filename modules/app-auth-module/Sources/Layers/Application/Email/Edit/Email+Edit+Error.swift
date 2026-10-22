public import AuthModule
public import FeatherApplication

extension Email.Edit.UseCase {
    public enum Error: FeatherApplication.UseCaseError {
        case authEmailNotFound
    }
}
