public import AuthModule
public import FeatherApplication

extension Email.Edit {
    public enum Error: FeatherApplication.UseCaseError {
        case authEmailNotFound
    }
}
