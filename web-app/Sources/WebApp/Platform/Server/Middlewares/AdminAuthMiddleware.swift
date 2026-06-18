import Hummingbird

struct AdminAuthMiddleware: RouterMiddleware {

    func handle(
        _ request: Request,
        context: AppRequestContext,
        next: (Request, AppRequestContext) async throws -> Response
    ) async throws -> Response {
        guard let account = context.account else {
            return Response(
                status: .seeOther,
                headers: [.location: "/login/"]
            )
        }
        guard account.canAccess("auth:admin:access") else {
            return Response(
                status: .seeOther,
                headers: [.location: "/"]
            )
        }
        return try await next(request, context)
    }
}
