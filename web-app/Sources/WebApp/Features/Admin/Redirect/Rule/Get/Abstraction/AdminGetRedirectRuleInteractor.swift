import Foundation

protocol AdminGetRedirectRuleInteractor: Sendable {

    func execute(
        entity: AdminGetRedirectRuleModel
    ) async throws -> RedirectRuleDetailsModel
}
