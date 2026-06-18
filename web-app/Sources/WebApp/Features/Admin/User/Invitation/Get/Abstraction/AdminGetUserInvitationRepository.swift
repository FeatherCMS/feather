import Foundation

protocol AdminGetUserInvitationRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserInvitationDetailsModel
}
