import Foundation

protocol AdminGetUserInvitationInteractor: Sendable {

    func execute(
        entity: AdminGetUserInvitationModel
    ) async throws -> UserInvitationDetailsModel
}
