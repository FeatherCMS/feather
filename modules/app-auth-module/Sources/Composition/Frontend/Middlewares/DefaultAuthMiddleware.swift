import AuthAppAPI
public import FeatherAdmin
public import Foundation
public import Hummingbird

public struct DefaultAuthMiddleware:
    RouterMiddleware
{
    private let middleware: AuthMiddleware

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
        context: DefaultRequestContext,
        next:
            @concurrent (Request, DefaultRequestContext) async throws ->
            Response
    ) async throws -> Response {
        try await middleware.handle(request, context: context, next: next)
    }
}
