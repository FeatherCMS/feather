public import AuthApplication
public import AuthModule
public import NIOHTTP1

extension AuthModule.Credential.Add.UseCase.Error: AuthUseCaseHTTPError {
    public var status: HTTPResponseStatus { .badRequest }
    var message: String { "Auth email not found" }

    var logMessage: String {
        switch self {
        case .authEmailNotFound(let identityId):
            "Auth email not found for identity: \(identityId)"
        }
    }
}
