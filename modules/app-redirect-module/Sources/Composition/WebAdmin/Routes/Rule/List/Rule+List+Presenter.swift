import RedirectModule
import FeatherWebAdmin
import RedirectAdminAPI
import RedirectApplication

extension RedirectModule.Rule.List {
    enum Presenter {}
}

extension RedirectModule.Rule.List.Presenter {
    protocol Interface: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.RedirectRuleQueryItemSchema>,
        permissions: AdminListActions,
        search: String?,
        statusCode: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(error: RedirectModule.Rule.List.Error) async throws
        -> HTMLResponse
    }
}
