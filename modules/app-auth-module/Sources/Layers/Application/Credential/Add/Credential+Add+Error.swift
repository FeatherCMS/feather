public import AuthModule
public import FeatherApplication

extension Credential.Add {
    public enum Error: FeatherApplication.UseCaseError {
        case authEmailNotFound(identityId: String)
    }
}
