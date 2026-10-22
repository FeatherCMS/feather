import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension Rule.List.Repository {
    protocol Interface: Sendable {

        func listRedirectRules(
            page: Int,
            search: String?,
            statusCode: Rule.StatusCode?
        ) async throws
            -> RedirectAdminAPI.Components.Responses
            .RedirectRuleQueryItemSearchSchemaSearchResponse

    }
}
