import AccountApplication
import AuthDomain
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
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
        _ = try await CredentialDatabaseRepository(context: context).insert(
            try Credential.create(
                userId: userID,
                email: email,
                passwordHash: passwordHash
            )
        )
    }
}
