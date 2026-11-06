public import AccountApplication
public import AccountModule
import AuthDomain
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
public import FeatherModuleKit

/// Adapts Account's registration port to Auth's credential infrastructure.
extension Invitation.CompleteRegistration {
    public struct CredentialWriterAdapter: CredentialWriter {

        public init() {}

        public func create(
            userID: String,
            email: String,
            password: String,
            context: any TransactionContext
        ) async throws {
            guard let context = context as? DatabaseTransactionContext else {
                throw CredentialWriterError.invalidTransactionContext
            }
            guard
                let authEmail = try await Email.Repository
                    .Database(
                        context: context
                    )
                    .findBy(email: email), authEmail.identityId == userID
            else {
                throw CredentialWriterError.authEmailNotFound
            }
            let passwordHash = try await BCryptPasswordHasher().hash(password)
            _ = try await Credential.Repository.Database(context: context)
                .insert(
                    try Credential.Model.create(
                        authEmailId: authEmail.id,
                        passwordHash: passwordHash
                    )
                )
        }
    }
}
