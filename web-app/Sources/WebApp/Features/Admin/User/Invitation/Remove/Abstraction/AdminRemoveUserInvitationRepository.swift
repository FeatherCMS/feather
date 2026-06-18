import Foundation

protocol AdminRemoveUserInvitationRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserInvitationDetailsModel

    func delete(
        id: String
    ) async throws
}
