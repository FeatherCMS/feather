import Foundation

protocol AdminEditRedirectRuleRepository: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel

    func update(
        id: String,
        input: RedirectRuleFormInput
    ) async throws
}
