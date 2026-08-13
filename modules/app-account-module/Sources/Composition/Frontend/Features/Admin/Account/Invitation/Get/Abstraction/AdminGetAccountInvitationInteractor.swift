import FeatherAdmin
import Foundation

protocol AdminGetAccountInvitationInteractor: Sendable {

    func execute(
        entity: AdminGetAccountInvitationModel
    ) async throws -> AccountInvitationDetailsModel
}
