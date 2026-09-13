import FeatherAdmin
import Foundation
import HTML
import Hummingbird

protocol AdminEditRedirectRuleController: Sendable {

    func getEditRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(RedirectRuleRoutes.editPattern.description + "/"),
            use: getEditRedirectRule
        )
        router.post(
            RouterPath(RedirectRuleRoutes.editPattern.description + "/"),
            use: postEditRedirectRule
        )
    }
}
