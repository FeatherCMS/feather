public import AuthModule
public import FeatherApplication

extension Credential.Add.UseCase {
    public enum Error: FeatherApplication.UseCaseError {
        case authEmailNotFound(identityId: String)
    }
}
