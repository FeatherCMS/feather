import Foundation

protocol AdminRemoveUserInvitationInteractor: Sendable {

    func get(
        id: String
    ) async throws -> UserInvitationDetailsModel

    func execute(
        entity: AdminRemoveUserInvitationModel
    ) async throws
}
