public import AccountModule
public import FeatherModuleKit

/// Creates Auth credentials within the invitation registration transaction.
extension Invitation.CompleteRegistration {
    public protocol CredentialWriter: Sendable {

        func create(
            userID: String,
            email: String,
            password: String,
            context: any TransactionContext
        ) async throws
    }
}
