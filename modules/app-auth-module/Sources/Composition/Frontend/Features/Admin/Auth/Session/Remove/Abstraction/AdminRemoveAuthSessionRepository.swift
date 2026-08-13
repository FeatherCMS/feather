import FeatherAdmin
import Foundation

protocol AdminRemoveAuthSessionRepository: Sendable {

    func get(
        identityId: String,
        sessionId: String
    ) async throws -> AdminRemoveAuthSessionModel

    func delete(
        identityId: String,
        sessionId: String
    ) async throws
}
