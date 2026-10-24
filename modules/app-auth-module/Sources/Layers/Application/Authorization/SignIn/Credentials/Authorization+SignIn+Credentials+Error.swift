public import AuthModule
public import FeatherApplication

extension AuthModule.Authorization.SignIn.Credentials.UseCase {
    public enum Error: FeatherApplication.UseCaseError {
        case authenticationFailed
    }
}
