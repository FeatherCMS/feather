import FeatherWebAdmin
import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension Rule.List {
    enum Interactor {}
}

extension Rule.List.Interactor {
    protocol Interface: Sendable {

        func listRedirectRules(
            page: Int,
            search: String?,
            statusCode: Rule.StatusCode?
        ) async throws -> AdminListModel<
            Components.Schemas.RedirectRuleQueryItemSchema
        >

    }
}
