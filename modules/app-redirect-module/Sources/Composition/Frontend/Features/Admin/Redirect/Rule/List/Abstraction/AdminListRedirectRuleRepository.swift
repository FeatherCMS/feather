import FeatherAdmin
import Foundation
import Hummingbird
import RedirectDomain

protocol AdminListRedirectRuleRepository: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: Rule.StatusCode?
    ) async throws -> AdminListRedirectRuleModel

    func delete(
        id: String
    ) async throws
}
