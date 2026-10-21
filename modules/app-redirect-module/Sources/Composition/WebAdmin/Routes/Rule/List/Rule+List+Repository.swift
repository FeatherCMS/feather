import RedirectAdminAPI
import RedirectModule

extension RedirectModule.Rule.List {
    enum Repository {}
}

extension RedirectModule.Rule.List.Repository {
    protocol Interface: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: RedirectModule.Rule.StatusCode?
    ) async throws
        -> RedirectAdminAPI.Components.Responses
        .RedirectRuleQueryItemSearchSchemaSearchResponse

    }
}
