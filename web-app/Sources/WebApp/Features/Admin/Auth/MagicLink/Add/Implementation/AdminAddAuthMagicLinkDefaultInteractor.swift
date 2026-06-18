import Foundation

struct AdminAddAuthMagicLinkDefaultInteractor: AdminAddAuthMagicLinkInteractor {
    let repository: any AdminAddAuthMagicLinkRepository

    func execute(
        entity: AdminAddAuthMagicLinkModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
