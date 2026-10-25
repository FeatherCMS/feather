import AccountModule
import AccountApplication

extension Invitation.CompleteRegistration {
    enum CredentialWriterError: Swift.Error {
        case invalidTransactionContext
        case authEmailNotFound
    }
}
