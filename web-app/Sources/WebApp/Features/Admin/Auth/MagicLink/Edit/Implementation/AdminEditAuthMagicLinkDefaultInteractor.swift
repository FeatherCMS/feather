import Foundation

struct AdminEditAuthMagicLinkDefaultInteractor: AdminEditAuthMagicLinkInteractor
{
    let repository: any AdminEditAuthMagicLinkRepository

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminEditAuthMagicLinkModel
    ) async throws {
        try await repository.update(
            id: entity.id,
            payload: entity.payload
        )
    }
}
