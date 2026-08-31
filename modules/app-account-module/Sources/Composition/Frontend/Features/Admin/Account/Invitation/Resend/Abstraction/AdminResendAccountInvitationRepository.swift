import FeatherAdmin

protocol AdminResendAccountInvitationRepository: Sendable {

    func resend(
        id: String
    ) async throws
}
