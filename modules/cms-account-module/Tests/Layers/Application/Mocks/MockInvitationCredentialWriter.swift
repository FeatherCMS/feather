import AccountModule
import FeatherModuleKit

@testable import AccountApplication

actor MockInvitationCredentialWriter:
    Invitation.CompleteRegistration.CredentialWriter
{
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
