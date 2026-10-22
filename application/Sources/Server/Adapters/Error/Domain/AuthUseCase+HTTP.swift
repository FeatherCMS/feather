public import AuthModule
import NIOHTTP1
public import FeatherBackend

private protocol AuthUseCaseHTTPError: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    var logMessage: String { get }
    var message: String { get }
}

extension AuthUseCaseHTTPError {

    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: logMessage,
            children: []
        )
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: logMessage
        )
    }
}

extension AuthModule.Credential.Add.UseCase.Error: AuthUseCaseHTTPError {

    public var status: HTTPResponseStatus { .badRequest }
    fileprivate var message: String { "Auth email not found" }

    fileprivate var logMessage: String {
        switch self {
        case .authEmailNotFound(let identityId):
            "Auth email not found for identity: \(identityId)"
        }
    }
}

extension AuthModule.Credential.Edit.UseCase.Error: AuthUseCaseHTTPError {

    public var status: HTTPResponseStatus { .badRequest }

    fileprivate var message: String {
        switch self {
        case .credentialNotFound:
            "Credential not found"
        case .authEmailNotFoundForCredential, .authEmailNotFoundForIdentity:
            "Auth email not found"
        }
    }

    fileprivate var logMessage: String {
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

extension AuthModule.Email.Edit.UseCase.Error: AuthUseCaseHTTPError {

    public var status: HTTPResponseStatus { .badRequest }
    fileprivate var message: String { "Auth email not found" }
    fileprivate var logMessage: String { "Auth email not found" }
}

extension AuthModule.MagicLink.Edit.UseCase.Error: AuthUseCaseHTTPError {

    public var status: HTTPResponseStatus { .badRequest }
    fileprivate var message: String { "Magic link not found" }

    fileprivate var logMessage: String {
        switch self {
        case .notFound(let id):
            "Magic link not found: \(id)"
        }
    }
}

extension AuthModule.Authorization.SignIn.Credentials.UseCase.Error:
    AuthUseCaseHTTPError
{
    public var status: HTTPResponseStatus { .unauthorized }
    fileprivate var message: String { "Authentication error." }
    fileprivate var logMessage: String { "authentication_error" }
}

extension AuthModule.Authorization.SignIn.MagicLink.UseCase.Error:
    AuthUseCaseHTTPError
{
    public var status: HTTPResponseStatus { .unauthorized }
    fileprivate var message: String { "Authentication error." }
    fileprivate var logMessage: String { "authentication_error" }
}
