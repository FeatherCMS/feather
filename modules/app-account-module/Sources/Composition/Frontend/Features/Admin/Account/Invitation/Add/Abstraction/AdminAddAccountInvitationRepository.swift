import FeatherAdmin

protocol AdminAddAccountInvitationRepository: Sendable {

    func create(
        payload: AccountInvitationFormPayloadModel
    ) async throws
}
