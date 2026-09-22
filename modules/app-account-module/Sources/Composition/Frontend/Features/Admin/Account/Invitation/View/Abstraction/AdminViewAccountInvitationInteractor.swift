
protocol AdminViewAccountInvitationInteractor: Sendable {
    func roleNames(for ids: [String]) async -> [String]

    func execute(
        entity: AdminViewAccountInvitationModel
    ) async throws -> AccountInvitationDetailsModel
}
