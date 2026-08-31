import FeatherContracts

/// Creates Auth credentials within the invitation registration transaction.
public protocol InvitationCredentialWriter: Sendable {

    func create(
        userID: String,
        email: String,
        password: String,
        context: any TransactionContext
    ) async throws
}
