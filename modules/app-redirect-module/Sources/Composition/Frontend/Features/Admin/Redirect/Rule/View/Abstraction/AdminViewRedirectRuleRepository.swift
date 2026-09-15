import FeatherAdmin
import Foundation

protocol AdminViewRedirectRuleRepository: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel
}
