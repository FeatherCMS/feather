import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Edit {
    enum Repository {}
}

extension Invitation.Edit.Repository {

    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> AccountInvitationDetailsModel

        func update(
            id: String,
            payload: Invitation.Form.Payload
        ) async throws
    }
}
