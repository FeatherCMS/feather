import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminViewRedirectOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewRedirectOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RedirectAdminRoutes.redirect,
            use: getOverview
        )
    }
}
