import Foundation

protocol AdminGetAuthMagicLinkRepository: Sendable {

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel
}
