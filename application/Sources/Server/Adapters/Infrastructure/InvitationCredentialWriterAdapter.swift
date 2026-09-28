import AccountApplication
import AuthDomain
import AuthInfrastructure
import FeatherContracts
import FeatherInfrastructure

/// Adapts Account's registration port to Auth's credential infrastructure.
struct InvitationCredentialWriterAdapter: InvitationCredentialWriter {

    func create(
        userID: String,
        email: String,
        password: String,
        context: any TransactionContext
    ) async throws {
        guard let context = context as? DatabaseTransactionContext else {
            throw InvitationCredentialWriterError.invalidTransactionContext
        }
        let passwordHash = try await BCryptPasswordHasher().hash(password)
        guard
            let authEmail = try await AuthEmailDatabaseRepository(
                context: context
            )
            .findBy(email: email), authEmail.identityId == userID
        else {
            throw InvitationCredentialWriterError.authEmailNotFound
        }
        _ = try await CredentialDatabaseRepository(context: context)
            .insert(
                try Credential.create(
                    authEmailId: authEmail.id,
                    passwordHash: passwordHash
                )
            )
    }
}
