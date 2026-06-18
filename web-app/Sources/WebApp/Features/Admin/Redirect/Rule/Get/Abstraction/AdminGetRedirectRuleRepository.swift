import Foundation

protocol AdminGetRedirectRuleRepository: Sendable {

    func get(
        id: String
    ) async throws -> RedirectRuleDetailsModel
}
