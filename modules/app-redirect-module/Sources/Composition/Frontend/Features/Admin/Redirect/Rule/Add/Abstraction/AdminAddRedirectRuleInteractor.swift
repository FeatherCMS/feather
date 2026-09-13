import FeatherAdmin
import Foundation

protocol AdminAddRedirectRuleInteractor: Sendable {

    func add(
        input: RedirectRuleAddFormInput
    ) async throws
}
