import Foundation

protocol AdminAddRedirectRuleInteractor: Sendable {

    func execute(
        input: RedirectRuleFormInput
    ) async throws
}
