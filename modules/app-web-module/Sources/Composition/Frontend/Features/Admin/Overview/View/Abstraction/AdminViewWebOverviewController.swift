import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebOverviewController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/",
            use: getOverview
        )
    }
}
