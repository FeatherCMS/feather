import FeatherContracts

@testable import AccountApplication

actor MockInvitationCredentialWriter: InvitationCredentialWriter {
    private(set) var createCallCount = 0
    private(set) var userID: String?
    private(set) var email: String?

    func create(
        userID: String,
        email: String,
        password: String,
        context: any TransactionContext
    ) async throws {
        createCallCount += 1
        self.userID = userID
        self.email = email
    }
}
