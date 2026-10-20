import FeatherWebAdmin

protocol AdminViewRedirectRulePresenter: Sendable {

    func renderDetailsPage(
        rule: RedirectRuleDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(error: AdminViewRedirectRuleError) async throws
        -> HTMLResponse
}
