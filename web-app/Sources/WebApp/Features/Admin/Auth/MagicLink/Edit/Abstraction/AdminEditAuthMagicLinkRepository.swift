import Foundation

protocol AdminEditAuthMagicLinkRepository: Sendable {

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel

    func update(
        id: String,
        payload: AuthMagicLinkFormPayloadModel
    ) async throws
}
