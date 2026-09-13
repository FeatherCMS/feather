import FeatherAdmin
import Foundation

protocol AdminGetRedirectRuleInteractor: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel
}
