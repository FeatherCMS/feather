import FeatherAdmin
import Foundation

struct AdminRemoveAuthSessionDefaultInteractor:
    AdminRemoveAuthSessionInteractor
{
    private let repository: any AdminRemoveAuthSessionRepository

    init(repository: any AdminRemoveAuthSessionRepository) {
        self.repository = repository
    }

    func get(
        identityId: String,
        sessionId: String
    ) async throws -> AdminRemoveAuthSessionModel {
        try await repository.get(identityId: identityId, sessionId: sessionId)
    }

    func execute(
        entity: AdminRemoveAuthSessionModel
    ) async throws {
        try await repository.delete(
            identityId: entity.identityId,
            sessionId: entity.sessionId
        )
    }
}
