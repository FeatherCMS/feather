public import AuthApplication
public import AuthModule
public import NIOHTTP1

extension AuthModule.MagicLink.Edit.UseCase.Error: AuthUseCaseHTTPError {
    public var status: HTTPResponseStatus { .badRequest }
    var message: String { "Magic link not found" }

    var logMessage: String {
        switch self {
        case .notFound(let id):
            "Magic link not found: \(id)"
        }
    }
}
