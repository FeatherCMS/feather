import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
import Hummingbird

struct AdminAuthMiddleware: RouterMiddleware {

    func handle(
        _ request: Request,
        context: AppRequestContext,
        next: @concurrent (Request, AppRequestContext) async throws -> Response
    ) async throws -> Response {
        guard let account = context.account else {
            return Response(
                status: .seeOther,
                headers: [.location: "/login/"]
            )
        }
        guard account.canAccess("system.admin.access") else {
            return Response(
                status: .seeOther,
                headers: [.location: "/"]
            )
        }
        return try await next(request, context)
    }
}
