import Foundation
public import FeatherModuleKit
public import FeatherWebShared
public import Hummingbird
public import SystemModule

public struct AuthMiddleware: RouterMiddleware {

    private let loginPath: String
    private let unauthorizedPath: String
    private let requiredPermission: PermissionKey

    public init(
        loginPath: String,
        unauthorizedPath: String,
        requiredPermission: PermissionKey = Admin.Permissions.access
    ) {
        self.loginPath = loginPath
        self.unauthorizedPath = unauthorizedPath
        self.requiredPermission = requiredPermission
    }

    public func handle(
        _ request: Request,
        context: DefaultRequestContext,
        next:
            @concurrent (Request, DefaultRequestContext) async throws ->
            Response
    ) async throws -> Response {
        guard let account = context.account else {
            var components = URLComponents()
            components.path = loginPath
            components.queryItems = [
                URLQueryItem(
                    name: "redirect",
                    value: request.uri.description
                )
            ]
            return Response(
                status: .seeOther,
                headers: [
                    .location: components.string ?? loginPath
                ]
            )
        }
        guard account.canAccess(requiredPermission.rawValue) else {
            return Response(
                status: .seeOther,
                headers: [.location: unauthorizedPath]
            )
        }
        return try await next(request, context)
    }
}
