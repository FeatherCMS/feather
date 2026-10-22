import AccountModule

extension Invitation.Detail.Repository {

    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> AccountInvitationDetailsModel
    }
}
