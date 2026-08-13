import FeatherAdmin
import Foundation
import Hummingbird
import RedirectDomain

protocol AdminListRedirectRuleInteractor: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: Rule.StatusCode?
    ) async throws -> AdminListRedirectRuleModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
