import AccountModule

extension Invitation.Detail.Interactor {

    protocol Interface: Sendable {
        func roleNames(for ids: [String]) async -> [String]

        func execute(
            entity: Invitation.Detail.Model
        ) async throws -> AccountInvitationDetailsModel
    }
}
