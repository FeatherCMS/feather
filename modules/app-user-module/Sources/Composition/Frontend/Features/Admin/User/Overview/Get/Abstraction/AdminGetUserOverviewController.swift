import FeatherAdmin
import Hummingbird

protocol AdminGetUserOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetUserOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(UserAdminRoutes.user.description + "/"),
            use: getOverview
        )
    }
}
