import FeatherAdmin
import Foundation

protocol AdminGetAccountInvitationRepository: Sendable {

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel
}
