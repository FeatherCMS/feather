import AuthApplication
import AuthModule
import FeatherModuleKit
import NIOHTTP1

public enum ErrorAdapter {

    public static func adapt(_ error: any Error) -> (any Error)? {
        if let error = error as? AuthError {
            let status: HTTPResponseStatus
            switch error.kind {
            case .unauthorized:
                status = .unauthorized
            case .forbidden:
                status = .forbidden
            }
            return AuthErrorAdapter(
                error: error,
                status: status,
                message: error.message,
                logMessage: error.message
            )
        }
        if let error = error as? Credential.Add.UseCase.Error {
            let identityId: String
            switch error {
            case .authEmailNotFound(let id):
                identityId = id
            }
            return AuthErrorAdapter(
                error: error,
                status: .badRequest,
                message: "Auth email not found",
                logMessage: "Auth email not found for identity: \(identityId)"
            )
        }
        if let error = error as? Credential.Edit.UseCase.Error {
            let message: String
            let logMessage: String
            switch error {
            case .credentialNotFound(let id):
                message = "Credential not found"
                logMessage = "Credential not found: \(id)"
            case .authEmailNotFoundForCredential(let id):
                message = "Auth email not found"
                logMessage = "Auth email not found for credential: \(id)"
            case .authEmailNotFoundForIdentity(let identityId):
                message = "Auth email not found"
                logMessage = "Auth email not found for identity: \(identityId)"
            }
            return AuthErrorAdapter(
                error: error,
                status: .badRequest,
                message: message,
                logMessage: logMessage
            )
        }
        if let error = error as? Email.Edit.UseCase.Error {
            return AuthErrorAdapter(
                error: error,
                status: .badRequest,
                message: "Auth email not found",
                logMessage: "Auth email not found"
            )
        }
        if let error = error as? MagicLink.Edit.UseCase.Error {
            let id: String
            switch error {
            case .notFound(let missingID):
                id = missingID
            }
            return AuthErrorAdapter(
                error: error,
                status: .badRequest,
                message: "Magic link not found",
                logMessage: "Magic link not found: \(id)"
            )
        }
        if let error = error as? Authorization.SignIn.Credentials.UseCase.Error
        {
            return AuthErrorAdapter(
                error: error,
                status: .unauthorized,
                message: "Authentication error.",
                logMessage: "authentication_error"
            )
        }
        if let error = error as? Authorization.SignIn.MagicLink.UseCase.Error {
            return AuthErrorAdapter(
                error: error,
                status: .unauthorized,
                message: "Authentication error.",
                logMessage: "authentication_error"
            )
        }
        return nil
    }
}
