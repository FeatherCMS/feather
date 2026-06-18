import Foundation

protocol AdminRemoveUserAccountSessionInteractor: Sendable {

    func get(
        accountId: String,
        sessionId: String
    ) async throws -> AdminRemoveUserAccountSessionModel

    func execute(
        entity: AdminRemoveUserAccountSessionModel
    ) async throws
}
