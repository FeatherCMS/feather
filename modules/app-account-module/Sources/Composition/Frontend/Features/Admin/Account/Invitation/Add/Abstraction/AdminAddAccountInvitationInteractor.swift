import FeatherAdmin
import Foundation

protocol AdminAddAccountInvitationInteractor: Sendable {

    func execute(
        entity: AdminAddAccountInvitationModel
    ) async throws
}
