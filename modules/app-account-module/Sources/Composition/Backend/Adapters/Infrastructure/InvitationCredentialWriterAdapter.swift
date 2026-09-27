public import AccountApplication
import AuthDomain
import AuthInfrastructure
public import FeatherContracts
import FeatherInfrastructure

/// Adapts Account's registration port to Auth's credential infrastructure.
public struct InvitationCredentialWriterAdapter: InvitationCredentialWriter {

    public init() {}

    public func create(
        userID: String,
        email: String,
        password: String,
        context: any TransactionContext
    ) async throws {
        guard let context = context as? DatabaseTransactionContext else {
            throw InvitationCredentialWriterError.invalidTransactionContext
        }
        guard let authEmail = try await AuthEmailDatabaseRepository(
            context: context
        ).findBy(email: email), authEmail.identityId == userID else {
            throw InvitationCredentialWriterError.authEmailNotFound
        }
        let passwordHash = try await BCryptPasswordHasher().hash(password)
        _ = try await CredentialDatabaseRepository(context: context)
            .insert(
                try Credential.create(
                    authEmailId: authEmail.id,
                    passwordHash: passwordHash
                )
            )
    }
}
