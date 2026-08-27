import FeatherContracts

public protocol InvitationCredentialWriter: Sendable {

    func create(
        userID: String,
        email: String,
        password: String,
        context: any TransactionContext
    ) async throws
}
