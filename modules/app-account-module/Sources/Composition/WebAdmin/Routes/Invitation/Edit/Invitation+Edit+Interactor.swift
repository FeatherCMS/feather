import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Edit {
    enum Interactor {}
}

extension Invitation.Edit.Interactor {

    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> AccountInvitationDetailsModel

        func execute(
            entity: Invitation.Edit.Model
        ) async throws
    }
}
