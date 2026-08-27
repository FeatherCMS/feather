import AuthAppAPI
import FeatherAdmin
import Foundation
import Hummingbird

public struct DefaultAuthMiddleware<Context: AuthRequestContext>:
    RouterMiddleware
{
    private let middleware: AuthMiddleware<Context>

    public init(
        apiBaseURL: URL,
        secureCookies: Bool = false
    ) {
        self.middleware = AuthMiddleware(
            secureCookies: secureCookies
        ) { sessionToken in
            let api = AuthAppAPIClient(
                apiBaseURL: apiBaseURL,
                sessionToken: sessionToken
            )
            return try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authMe()
                let payload = try response.ok.body.json
                return AccountModel(
                    user: .init(id: payload.user.id),
                    permissions: payload.permissions,
                    roles: payload.roles
                )
            }
        }
    }

    public func handle(
        _ request: Request,
        context: Context,
        next: @concurrent (Request, Context) async throws -> Response
    ) async throws -> Response {
        try await middleware.handle(request, context: context, next: next)
    }
}
