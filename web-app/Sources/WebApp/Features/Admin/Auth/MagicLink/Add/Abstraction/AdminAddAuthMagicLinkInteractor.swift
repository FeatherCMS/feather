import Foundation

protocol AdminAddAuthMagicLinkInteractor: Sendable {

    func execute(
        entity: AdminAddAuthMagicLinkModel
    ) async throws
}
