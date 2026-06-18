import Foundation

protocol AdminGetAuthMagicLinkInteractor: Sendable {

    func execute(
        entity: AdminGetAuthMagicLinkModel
    ) async throws -> AuthMagicLinkDetailsModel
}
