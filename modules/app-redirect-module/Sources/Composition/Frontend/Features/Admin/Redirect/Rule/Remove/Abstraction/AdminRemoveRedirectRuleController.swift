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
            RedirectRuleRoutes.remove(RouterPath("{id}")),
            use: getRemoveRedirectRule
        )
        router.post(
            RedirectRuleRoutes.remove(RouterPath("{id}")),
            use: postRemoveRedirectRule
        )
        router.get(
            RedirectRuleRoutes.remove,
            use: getRemoveRedirectRules
        )
        router.post(
            RedirectRuleRoutes.remove,
            use: postRemoveRedirectRules
        )
    }
}
