import FeatherWebAdmin
import RedirectAdminAPI
import RedirectContracts

protocol AdminListRedirectRuleInteractor: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: StatusCode?
    ) async throws -> AdminListModel<
        Components.Schemas.RedirectRuleListItemSchema
    >

}
