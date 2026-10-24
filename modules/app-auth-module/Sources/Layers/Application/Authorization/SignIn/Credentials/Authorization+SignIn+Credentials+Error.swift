public import AuthModule
public import FeatherApplication

extension AuthModule.Authorization.SignIn.Credentials {
    public enum Error: FeatherApplication.UseCaseError {
        case authenticationFailed
    }
}
