import Foundation

protocol AdminAddUserInvitationRepository: Sendable {

    func create(
        payload: UserInvitationFormPayloadModel
    ) async throws
}
