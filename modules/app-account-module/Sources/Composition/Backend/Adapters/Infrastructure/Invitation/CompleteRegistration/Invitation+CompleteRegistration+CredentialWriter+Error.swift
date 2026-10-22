import AccountModule

extension Invitation.CompleteRegistration {
    enum CredentialWriterError: Error {
        case invalidTransactionContext
        case authEmailNotFound
    }
}
