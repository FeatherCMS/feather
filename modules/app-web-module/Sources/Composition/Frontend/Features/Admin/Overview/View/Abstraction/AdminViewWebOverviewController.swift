import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/",
            use: getOverview
        )
    }
}
