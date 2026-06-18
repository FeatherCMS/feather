import Foundation

protocol AdminRemoveRedirectRuleInteractor: Sendable {

    func get(
        id: String
    ) async throws -> RedirectRuleDetailsModel

    func delete(
        id: String
    ) async throws
}
