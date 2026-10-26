public import AuthModule
public import FeatherApplication

extension Credential.Edit {
    public enum Error: FeatherApplication.UseCaseError {
        case credentialNotFound(id: String)
        case authEmailNotFoundForCredential(id: String)
        case authEmailNotFoundForIdentity(identityId: String)
    }
}
