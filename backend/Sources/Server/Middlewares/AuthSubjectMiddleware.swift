import OpenAPIRuntime
import HTTPTypes
import Application
import UserApplication
import AuthApplication
import Domain
import Hummingbird

struct AuthSubjectMiddleware: ServerMiddleware {

    private static let sessionCookieName = "session"
    private let modules: AppModules

    init(modules: AppModules) {
        self.modules = modules
    }

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: MiddlewareNextBlock
    ) async throws -> (HTTPResponse, HTTPBody?) {

        var token: String?
        let cookies = request.headerFields[.cookie].map { Cookies(from: [$0]) }
        if let id = cookies?[Self.sessionCookieName]?.value {
            token = id
        }
        if let bearerToken = request.headerFields[.authorization] {
            let prefix = "Bearer "
            if bearerToken.hasPrefix(prefix) {
                token = String(bearerToken.dropFirst(prefix.count))
            }
        }
        guard let token, !token.isEmpty else {
            return try await next(request, body, metadata)
        }

        let useCase = modules.auth.makeTokenAuth()

        guard
            let auth = try await useCase.execute(.init(token: token))
        else {
            return try await next(request, body, metadata)
        }
        let subject = Subject(id: auth.accountId)

        return try await CurrentSubject.set(subject: subject) {
            return try await next(request, body, metadata)
        }
    }
}
