import FeatherAdmin
import Foundation

protocol AdminEditAccountInvitationInteractor: Sendable {

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel

    func execute(
        entity: AdminEditAccountInvitationModel
    ) async throws
}
