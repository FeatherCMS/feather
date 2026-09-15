import FeatherAdmin
import Foundation

protocol AdminEditRedirectRuleInteractor: Sendable {

    func load(
        id: String
    ) async throws -> RedirectRuleEditModel

    func update(
        id: String,
        input: RedirectRuleEditFormInput
    ) async throws
}
