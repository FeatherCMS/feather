import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminGetRedirectHomeController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetRedirectHomeController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/redirect/",
            use: getHome
        )
    }
}
