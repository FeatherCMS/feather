import FeatherWebAdmin
import RedirectAdminAPI
import RedirectApplication
import RedirectModule
import RedirectDomain

extension Rule.List {
    enum Interactor {}
}

extension Rule.List.Interactor {
    protocol Interface: Sendable {

        func listRedirectRules(
            page: Int,
            search: String?,
            statusCode: Rule.Model.StatusCode?
        ) async throws -> AdminListModel<
            Components.Schemas.RedirectRuleQueryItemSchema
        >

    }
}
