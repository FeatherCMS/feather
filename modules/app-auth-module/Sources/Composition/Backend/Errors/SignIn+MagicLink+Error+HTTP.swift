public import AuthApplication
public import AuthModule
public import NIOHTTP1

extension AuthModule.Authorization.SignIn.MagicLink.UseCase.Error:
    AuthUseCaseHTTPError
{
    public var status: HTTPResponseStatus { .unauthorized }
    var message: String { "Authentication error." }
    var logMessage: String { "authentication_error" }
}
