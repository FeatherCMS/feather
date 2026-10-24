public import AuthModule
public import FeatherApplication

extension AuthModule.Authorization.SignIn.MagicLink.UseCase {
    public enum Error: FeatherApplication.UseCaseError {
        case authenticationFailed
    }
}
