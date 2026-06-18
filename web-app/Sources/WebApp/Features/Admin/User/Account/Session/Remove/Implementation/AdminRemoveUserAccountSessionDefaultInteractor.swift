import Foundation

struct AdminRemoveUserAccountSessionDefaultInteractor:
    AdminRemoveUserAccountSessionInteractor
{
    private let repository: any AdminRemoveUserAccountSessionRepository

    init(repository: any AdminRemoveUserAccountSessionRepository) {
        self.repository = repository
    }

    func get(
        accountId: String,
        sessionId: String
    ) async throws -> AdminRemoveUserAccountSessionModel {
        try await repository.get(accountId: accountId, sessionId: sessionId)
    }

    func execute(
        entity: AdminRemoveUserAccountSessionModel
    ) async throws {
        try await repository.delete(
            accountId: entity.accountId,
            sessionId: entity.sessionId
        )
    }
}
