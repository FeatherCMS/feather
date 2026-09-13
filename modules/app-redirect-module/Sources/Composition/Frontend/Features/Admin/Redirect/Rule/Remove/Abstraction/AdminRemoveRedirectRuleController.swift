import FeatherAdmin
import Foundation
import HTML
import Hummingbird

protocol AdminRemoveRedirectRuleController: Sendable {

    func getRemoveRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func getRemoveRedirectRules(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postRemoveRedirectRules(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(RedirectRuleRoutes.removePattern.description + "/"),
            use: getRemoveRedirectRule
        )
        router.post(
            RouterPath(RedirectRuleRoutes.removePattern.description + "/"),
            use: postRemoveRedirectRule
        )
        router.get(
            RouterPath(RedirectRuleRoutes.remove.description + "/"),
            use: getRemoveRedirectRules
        )
        router.post(
            RouterPath(RedirectRuleRoutes.remove.description + "/"),
            use: postRemoveRedirectRules
        )
    }
}
