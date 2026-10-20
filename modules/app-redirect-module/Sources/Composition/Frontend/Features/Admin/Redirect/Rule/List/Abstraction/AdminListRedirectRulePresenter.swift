import FeatherWebAdmin
import RedirectAdminAPI

protocol AdminListRedirectRulePresenter: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.RedirectRuleListItemSchema>,
        permissions: AdminListActions,
        search: String?,
        statusCode: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(error: AdminListRedirectRuleError) async throws
        -> HTMLResponse
}
