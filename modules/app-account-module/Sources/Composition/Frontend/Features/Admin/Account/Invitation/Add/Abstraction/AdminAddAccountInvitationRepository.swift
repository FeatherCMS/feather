import FeatherAdmin
import Foundation

protocol AdminAddAccountInvitationRepository: Sendable {

    func create(
        payload: AccountInvitationFormPayloadModel
    ) async throws
}
