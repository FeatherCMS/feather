import Foundation

protocol AdminRemoveAuthMagicLinkInteractor: Sendable {

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel

    func execute(
        entity: AdminRemoveAuthMagicLinkModel
    ) async throws
}
