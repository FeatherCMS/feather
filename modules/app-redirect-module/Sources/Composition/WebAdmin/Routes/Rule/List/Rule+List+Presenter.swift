import RedirectModule
import FeatherWebAdmin
import RedirectAdminAPI

extension RedirectModule.Rule.List {
    enum Presenter {}
}

extension RedirectModule.Rule.List.Presenter {
    protocol Interface: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.RedirectRuleListItemSchema>,
        permissions: AdminListActions,
        search: String?,
        statusCode: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(error: RedirectModule.Rule.List.Error) async throws
        -> HTMLResponse
    }
}
