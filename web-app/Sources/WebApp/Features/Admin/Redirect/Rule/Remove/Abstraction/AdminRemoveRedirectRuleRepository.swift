import Foundation

protocol AdminRemoveRedirectRuleRepository: Sendable {

    func get(
        id: String
    ) async throws -> RedirectRuleDetailsModel

    func delete(
        id: String
    ) async throws
}
