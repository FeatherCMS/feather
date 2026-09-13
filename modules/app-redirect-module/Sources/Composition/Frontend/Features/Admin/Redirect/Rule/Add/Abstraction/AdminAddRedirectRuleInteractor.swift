import FeatherAdmin
import Foundation

protocol AdminAddRedirectRuleInteractor: Sendable {

    func add(
        input: RedirectRuleFormInput
    ) async throws
}
