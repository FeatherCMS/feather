import AccountModule

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
