import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminGetRedirectRuleController: Sendable {

    func getRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(RedirectRuleRoutes.detailsPattern.description + "/"),
            use: getRedirectRule
        )
    }
}
