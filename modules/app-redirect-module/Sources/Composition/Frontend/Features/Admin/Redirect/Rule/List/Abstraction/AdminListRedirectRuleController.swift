import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminListRedirectRuleController: Sendable {

    func getRedirectRules(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RedirectRuleRoutes.list,
            use: getRedirectRules
        )
    }
}
