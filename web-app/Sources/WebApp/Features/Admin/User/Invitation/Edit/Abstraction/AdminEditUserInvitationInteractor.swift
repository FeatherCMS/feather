import Foundation

protocol AdminEditUserInvitationInteractor: Sendable {

    func get(
        id: String
    ) async throws -> UserInvitationDetailsModel

    func execute(
        entity: AdminEditUserInvitationModel
    ) async throws
}
