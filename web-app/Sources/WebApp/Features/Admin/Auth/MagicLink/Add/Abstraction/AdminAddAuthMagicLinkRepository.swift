import Foundation

protocol AdminAddAuthMagicLinkRepository: Sendable {

    func create(
        payload: AuthMagicLinkFormPayloadModel
    ) async throws
}
