import FeatherAdmin

protocol AdminRemoveAuthSessionInteractor: Sendable {

    func get(
        identityId: String,
        sessionId: String
    ) async throws -> AdminRemoveAuthSessionModel

    func execute(
        entity: AdminRemoveAuthSessionModel
    ) async throws
}
