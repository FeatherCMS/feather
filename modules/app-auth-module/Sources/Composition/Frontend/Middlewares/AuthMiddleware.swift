import FeatherAdmin
import Hummingbird

public struct AuthMiddleware<Context: AuthRequestContext>: RouterMiddleware {

    private let authenticate: @Sendable (String) async throws -> AccountModel
    private let secureCookies: Bool

    public init(
        secureCookies: Bool = false,
        authenticate: @escaping @Sendable (String) async throws -> AccountModel
    ) {
        self.authenticate = authenticate
        self.secureCookies = secureCookies
    }

    public func handle(
        _ request: Request,
        context: Context,
        next: @concurrent (Request, Context) async throws -> Response
    ) async throws -> Response {
        let path = request.uri.path

        if path.hasPrefix("/.well-known") || path.hasSuffix("favicon.ico") {
            return try await next(request, context)
        }

        guard
            let sessionToken = request.cookies["session_token"]?.value,
            !sessionToken.isEmpty
        else {
            return try await next(request, context)
        }

        var context = context
        context.sessionToken = sessionToken
        do {
            let account = try await authenticate(sessionToken)
            context.account = account
        }
        catch {
            let shouldClearSession =
                (error as? OpenAPIRepositoryError)?.httpStatus.code == 500
            let userAgent = request.headers[.userAgent] ?? "-"
            let referer = request.headers[.referer] ?? "-"
            let origin = request.headers[.origin] ?? "-"
            let secFetchSite = request.headers[.init("Sec-Fetch-Site")!] ?? "-"
            let secFetchMode = request.headers[.init("Sec-Fetch-Mode")!] ?? "-"
            let secFetchDest = request.headers[.init("Sec-Fetch-Dest")!] ?? "-"

            print("==== SESSION ERROR ====")
            print("Request: \(request.method) \(request.uri)")
            print("User-Agent: \(userAgent)")
            print("Referer: \(referer)")
            print("Origin: \(origin)")
            print("Sec-Fetch-Site: \(secFetchSite)")
            print("Sec-Fetch-Mode: \(secFetchMode)")
            print("Sec-Fetch-Dest: \(secFetchDest)")
            print("\(type(of: error))")
            print("\(error)")

            var response = try await next(request, context)
            if shouldClearSession {
                response.setCookie(
                    Cookie(
                        name: "session_token",
                        value: "",
                        maxAge: 0,
                        path: "/",
                        secure: secureCookies,
                        httpOnly: true,
                        sameSite: .lax
                    )
                )
            }
            return response
        }
        return try await next(request, context)
    }
}
