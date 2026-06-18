import Foundation

protocol AdminEditAuthMagicLinkInteractor: Sendable {

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel

    func execute(
        entity: AdminEditAuthMagicLinkModel
    ) async throws
}
