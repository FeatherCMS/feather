import AccountModule

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
