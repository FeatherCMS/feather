import FeatherAdmin
import Foundation

protocol AdminGetRedirectRuleRepository: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel
}
