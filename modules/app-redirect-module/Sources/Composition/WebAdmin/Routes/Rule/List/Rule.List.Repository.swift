import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension Rule.List {
    enum Repository {}
}

extension Rule.List.Repository {
    protocol Interface: Sendable {

        func search(
            page: Int,
            search: String?,
            statusCode: Rule.StatusCode?
        ) async throws
            -> RedirectAdminAPI.Components.Responses
            .RedirectRuleQueryItemSearchSchemaSearchResponse

    }
}
