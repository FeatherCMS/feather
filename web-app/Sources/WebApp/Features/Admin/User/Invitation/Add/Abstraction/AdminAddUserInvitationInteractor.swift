import Foundation

protocol AdminAddUserInvitationInteractor: Sendable {

    func execute(
        entity: AdminAddUserInvitationModel
    ) async throws
}
