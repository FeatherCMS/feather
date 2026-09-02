import FeatherAdmin
import Foundation
import Hummingbird
import RedirectContracts

protocol AdminListRedirectRuleInteractor: Sendable {

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: StatusCode?
    ) async throws -> AdminListRedirectRuleModel

    func remove(
        ids: [String]
    ) async throws
}
