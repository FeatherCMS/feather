import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

protocol AdminViewAnalyticsLogController: Sendable {

    func getAnalyticsLog(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsLogController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            Router.Routes.log(RouterPath("{id}")),
            use: getAnalyticsLog
        )
    }
}
