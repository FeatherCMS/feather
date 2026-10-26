import RedirectAdminAPI
import RedirectApplication
import RedirectModule
import RedirectDomain

extension Rule.List {
    enum Repository {}
}

extension Rule.List.Repository {
    protocol Interface: Sendable {

        func search(
            page: Int,
            search: String?,
            statusCode: Rule.Model.StatusCode?
        ) async throws
            -> RedirectAdminAPI.Components.Responses
            .RedirectRuleQueryItemSearchSchemaSearchResponse

    }
}
