import FeatherAdmin

protocol AdminViewRedirectRulePresenter: Sendable {

    func renderDetailsPage(
        rule: RedirectRuleDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(error: AdminViewRedirectRuleError) async throws
        -> HTMLResponse
}
