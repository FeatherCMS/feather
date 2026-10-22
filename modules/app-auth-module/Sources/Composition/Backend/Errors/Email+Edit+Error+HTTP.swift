public import AuthApplication
public import AuthModule
public import NIOHTTP1

extension AuthModule.Email.Edit.UseCase.Error: AuthUseCaseHTTPError {
    public var status: HTTPResponseStatus { .badRequest }
    var message: String { "Auth email not found" }
    var logMessage: String { "Auth email not found" }
}
