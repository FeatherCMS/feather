import AccountModule

extension Invitation.Resend.Repository {

    protocol Interface: Sendable {

        func resend(
            id: String
        ) async throws
    }
}
