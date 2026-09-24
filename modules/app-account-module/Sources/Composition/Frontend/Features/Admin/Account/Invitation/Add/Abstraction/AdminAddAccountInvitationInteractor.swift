protocol AdminAddAccountInvitationInteractor: Sendable {

    func execute(
        entity: AdminAddAccountInvitationModel
    ) async throws
}
