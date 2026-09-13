import FeatherAdmin
import Foundation
import HTML

protocol AdminGetRedirectRulePresenter: Sendable {

    func renderDetailsPage(
        rule: RedirectRuleDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(error: AdminGetRedirectRuleError) async throws -> HTMLResponse
}
