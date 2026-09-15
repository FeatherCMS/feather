import FeatherAdmin
import Foundation

protocol AdminAddRedirectRuleRepository: Sendable {

    func create(
        input: RedirectRuleAddFormInput
    ) async throws
}
