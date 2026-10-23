import AccountModule
import AccountApplication

extension Invitation.CompleteRegistration {
    enum CredentialWriterError: Error {
        case invalidTransactionContext
        case authEmailNotFound
    }
}
