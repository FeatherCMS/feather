import FeatherAdmin
import Hummingbird
import RedirectAdminAPI
import RedirectContracts

protocol AdminListRedirectRuleRepository: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: StatusCode?
    ) async throws
        -> RedirectAdminAPI.Components.Responses
        .RedirectRuleListItemSearchSchemaSearchResponse

}
