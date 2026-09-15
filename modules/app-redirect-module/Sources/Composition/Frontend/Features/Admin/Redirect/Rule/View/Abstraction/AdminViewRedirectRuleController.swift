import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminViewRedirectRuleController: Sendable {

    func getRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RedirectRuleRoutes.details(RouterPath("{id}")),
            use: getRedirectRule
        )
    }
}
