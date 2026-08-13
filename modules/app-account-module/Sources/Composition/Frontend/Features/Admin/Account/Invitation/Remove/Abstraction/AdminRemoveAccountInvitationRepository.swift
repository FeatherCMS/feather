import FeatherAdmin
import Foundation

protocol AdminRemoveAccountInvitationRepository: Sendable {

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel

    func delete(
        id: String
    ) async throws
}
