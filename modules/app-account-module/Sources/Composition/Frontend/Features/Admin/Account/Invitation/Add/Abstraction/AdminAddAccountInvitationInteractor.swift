import FeatherAdmin

protocol AdminAddAccountInvitationInteractor: Sendable {

    func execute(
        entity: AdminAddAccountInvitationModel
    ) async throws
}
