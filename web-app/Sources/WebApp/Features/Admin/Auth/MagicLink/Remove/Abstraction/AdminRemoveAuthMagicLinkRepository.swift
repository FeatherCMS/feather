import Foundation

protocol AdminRemoveAuthMagicLinkRepository: Sendable {

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel

    func delete(
        id: String
    ) async throws
}
