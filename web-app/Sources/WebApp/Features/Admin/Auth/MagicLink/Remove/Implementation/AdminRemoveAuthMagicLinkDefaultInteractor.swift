import Foundation

struct AdminRemoveAuthMagicLinkDefaultInteractor:
    AdminRemoveAuthMagicLinkInteractor
{
    let repository: any AdminRemoveAuthMagicLinkRepository

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminRemoveAuthMagicLinkModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
