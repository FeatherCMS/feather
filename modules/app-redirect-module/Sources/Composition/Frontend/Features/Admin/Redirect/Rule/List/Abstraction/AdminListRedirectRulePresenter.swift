import FeatherAdmin
import RedirectAdminAPI

protocol AdminListRedirectRulePresenter: Sendable {

    func renderListPage(
        model: NewAdminListModel<Components.Schemas.RedirectRuleListItemSchema>,
        permissions: NewAdminListActions,
        search: String?,
        statusCode: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(error: AdminListRedirectRuleError) async throws
        -> HTMLResponse
}
