import FeatherWebAdmin
import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension Rule.List.Presenter {
    protocol Interface: Sendable {

        func renderListPage(
            model: AdminListModel<
                Components.Schemas.RedirectRuleQueryItemSchema
            >,
            permissions: AdminListActions,
            search: String?,
            statusCode: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(error: Rule.List.Error) async throws
            -> HTMLResponse
    }
}
