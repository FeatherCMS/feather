public import FeatherAdmin
public import FeatherContracts
public import Hummingbird
public import SystemContracts

public struct AdminAuthMiddleware: RouterMiddleware {

    public typealias Context = DefaultRequestContext

    private let loginPath: String
    private let unauthorizedPath: String
    private let requiredPermission: PermissionKey

    public init(
        loginPath: String,
        unauthorizedPath: String,
        requiredPermission: PermissionKey = SystemPermissions.Admin.access
    ) {
        self.loginPath = loginPath
        self.unauthorizedPath = unauthorizedPath
        self.requiredPermission = requiredPermission
    }

    public func handle(
        _ request: Request,
        context: Context,
        next: @concurrent (Request, Context) async throws -> Response
    ) async throws -> Response {
        guard let account = context.account else {
            return Response(
                status: .seeOther,
                headers: [.location: loginPath]
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
