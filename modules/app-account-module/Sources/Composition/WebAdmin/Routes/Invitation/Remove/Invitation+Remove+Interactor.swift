import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove {
    enum Interactor {}
}

extension Invitation.Remove.Interactor {

    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> AccountInvitationDetailsModel

        func execute(
            entity: Invitation.Remove.Model
        ) async throws

        func execute(ids: [String]) async throws
    }
}
