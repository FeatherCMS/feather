import FeatherAdmin
import Foundation

protocol AdminViewRedirectRuleInteractor: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel
}
