import FeatherWebAdmin
import RedirectAdminAPI
import RedirectModule

extension RedirectModule.Rule.List {
    enum Interactor {}
}

extension RedirectModule.Rule.List.Interactor {
    protocol Interface: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: RedirectModule.Rule.StatusCode?
    ) async throws -> AdminListModel<
        Components.Schemas.RedirectRuleListItemSchema
    >

    }
}
