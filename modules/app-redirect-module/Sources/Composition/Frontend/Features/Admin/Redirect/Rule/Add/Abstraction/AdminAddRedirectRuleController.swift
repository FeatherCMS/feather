import FeatherAdmin
import Foundation
import HTML
import Hummingbird

protocol AdminAddRedirectRuleController: Sendable {

    func getAddRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(RedirectRuleRoutes.add.description + "/"),
            use: getAddRedirectRule
        )
        router.post(
            RouterPath(RedirectRuleRoutes.add.description + "/"),
            use: postAddRedirectRule
        )
    }
}
