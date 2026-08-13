import FeatherAdmin
import Foundation

protocol AdminRemoveAccountInvitationInteractor: Sendable {

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel

    func execute(
        entity: AdminRemoveAccountInvitationModel
    ) async throws
}
