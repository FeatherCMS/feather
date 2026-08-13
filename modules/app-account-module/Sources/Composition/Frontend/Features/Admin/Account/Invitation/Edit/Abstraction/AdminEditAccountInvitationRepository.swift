import FeatherAdmin
import Foundation

protocol AdminEditAccountInvitationRepository: Sendable {

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel

    func update(
        id: String,
        payload: AccountInvitationFormPayloadModel
    ) async throws
}
