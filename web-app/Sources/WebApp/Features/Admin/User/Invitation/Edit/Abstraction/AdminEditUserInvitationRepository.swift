import Foundation

protocol AdminEditUserInvitationRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserInvitationDetailsModel

    func update(
        id: String,
        payload: UserInvitationFormPayloadModel
    ) async throws
}
