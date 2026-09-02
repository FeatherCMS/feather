import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminListRedirectRuleController: Sendable {

    func getRedirectRules(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getRedirectRulesRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postRedirectRulesRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/redirect/rules",
            use: getRedirectRules
        )
        router.get(
            "/admin/redirect/rules/remove/",
            use: getRedirectRulesRemoveConfirmation
        )
        router.post(
            "/admin/redirect/rules/remove/",
            use: postRedirectRulesRemove
        )
    }
}
