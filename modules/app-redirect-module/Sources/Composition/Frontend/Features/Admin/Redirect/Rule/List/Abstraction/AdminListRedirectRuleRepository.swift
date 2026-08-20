import FeatherAdmin
import Foundation
import Hummingbird
import RedirectContracts

protocol AdminListRedirectRuleRepository: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: StatusCode?
    ) async throws -> AdminListRedirectRuleModel

    func delete(
        id: String
    ) async throws
}
