import Foundation

protocol AdminAddRedirectRuleRepository: Sendable {

    func create(
        input: RedirectRuleFormInput
    ) async throws
}
