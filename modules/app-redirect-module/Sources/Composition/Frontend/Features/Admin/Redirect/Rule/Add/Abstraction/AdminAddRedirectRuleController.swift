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
            "/admin/redirect/rules/add/",
            use: getAddRedirectRule
        )
        router.post(
            "/admin/redirect/rules/add/",
            use: postAddRedirectRule
        )
    }
}
