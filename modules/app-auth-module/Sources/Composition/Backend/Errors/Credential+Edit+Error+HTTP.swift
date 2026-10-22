public import AuthApplication
public import AuthModule
public import NIOHTTP1

extension AuthModule.Credential.Edit.UseCase.Error: AuthUseCaseHTTPError {
    public var status: HTTPResponseStatus { .badRequest }

    var message: String {
        switch self {
        case .credentialNotFound:
            "Credential not found"
        case .authEmailNotFoundForCredential, .authEmailNotFoundForIdentity:
            "Auth email not found"
        }
    }

    var logMessage: String {
        switch self {
        case .credentialNotFound(let id):
            "Credential not found: \(id)"
        case .authEmailNotFoundForCredential(let id):
            "Auth email not found for credential: \(id)"
        case .authEmailNotFoundForIdentity(let identityId):
            "Auth email not found for identity: \(identityId)"
        }
    }
}
