import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminListRedirectRuleController: Sendable {

    func getRedirectRules(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getRedirectRulesBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postRedirectRulesBulkRemove(
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
            "/admin/redirect/rules/bulk-remove/",
            use: getRedirectRulesBulkRemoveConfirmation
        )
        router.post(
            "/admin/redirect/rules/bulk-remove/",
            use: postRedirectRulesBulkRemove
        )
    }
}
