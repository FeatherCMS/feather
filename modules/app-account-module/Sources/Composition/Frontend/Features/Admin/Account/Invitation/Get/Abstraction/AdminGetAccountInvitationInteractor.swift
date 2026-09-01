import FeatherAdmin
import Foundation

protocol AdminGetAccountInvitationInteractor: Sendable {
    func roleNames(for ids: [String]) async -> [String]

    func execute(
        entity: AdminGetAccountInvitationModel
    ) async throws -> AccountInvitationDetailsModel
}
