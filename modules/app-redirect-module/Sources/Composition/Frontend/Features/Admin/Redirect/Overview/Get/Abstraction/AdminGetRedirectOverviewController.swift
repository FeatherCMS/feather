import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminGetRedirectOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetRedirectOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(RedirectAdminRoutes.redirect.description + "/"),
            use: getOverview
        )
    }
}
