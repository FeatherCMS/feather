import Foundation

protocol AdminRemoveUserAccountSessionRepository: Sendable {

    func get(
        accountId: String,
        sessionId: String
    ) async throws -> AdminRemoveUserAccountSessionModel

    func delete(
        accountId: String,
        sessionId: String
    ) async throws
}
