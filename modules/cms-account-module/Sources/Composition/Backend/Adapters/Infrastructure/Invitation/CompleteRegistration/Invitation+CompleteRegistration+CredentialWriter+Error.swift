import AccountApplication
import AccountModule

extension Invitation.CompleteRegistration {
    enum CredentialWriterError: Swift.Error {
        case invalidTransactionContext
        case authEmailNotFound
    }
}
