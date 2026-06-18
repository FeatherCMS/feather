import Foundation

struct AdminGetAuthMagicLinkDefaultInteractor: AdminGetAuthMagicLinkInteractor {
    let repository: any AdminGetAuthMagicLinkRepository

    func execute(
        entity: AdminGetAuthMagicLinkModel
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: entity.id)
    }
}
