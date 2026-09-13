import FeatherAdmin
import Foundation

protocol AdminViewAccountInvitationRepository: Sendable {

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel
}
