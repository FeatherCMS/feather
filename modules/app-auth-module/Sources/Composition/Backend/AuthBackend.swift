import AuthAdminAPI
import AuthAppAPI
import AuthApplication
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import UserApplication
import UserBackend
import UserInfrastructure

public struct AuthBackend: Sendable, AuthAdminAPI.APIProtocol, AuthAppAPI
        .APIProtocol
{
    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    private let authorizer: any Authorizer
    public let user: UserBackend

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        user: UserBackend
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.user = user
    }

    func aggregatedPermissions() {
        var permissions: [PermissionKey] = []
        permissions += AuthPermissions.allPermissions()
        permissions += SystemPermissions.allPermissions()
        permissions += UserPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

private struct NoopMailSender: MailSender {
    func send(
        _ message: MailMessage
    ) async throws {}
}

extension AuthBackend {

    public func makeGetCurrentUser() -> AuthApplication.GetCurrentUser {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadIdentity(
                    identity: IdentityDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    public func makeTokenAuth() -> TokenAuth {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAuth(
                    identity: IdentityDatabaseRepository(context: context),
                    credential: CredentialDatabaseRepository(context: context),
                    session: SessionDatabaseRepository(context: context),
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return TokenAuth(
            transaction: transaction
        )
    }

    func makeSignInWithCredentials() -> SignInWithCredentials {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAuth(
                    identity: IdentityDatabaseRepository(context: context),
                    credential: CredentialDatabaseRepository(context: context),
                    session: SessionDatabaseRepository(context: context),
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return SignInWithCredentials(
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }

    func makeSignInWithMagicLink() -> SignInWithMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAuth(
                    identity: IdentityDatabaseRepository(context: context),
                    credential: CredentialDatabaseRepository(context: context),
                    session: SessionDatabaseRepository(context: context),
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return SignInWithMagicLink(transaction: transaction)
    }

    func makeRequestMagicLink() -> RequestMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAuth(
                    identity: IdentityDatabaseRepository(context: context),
                    credential: CredentialDatabaseRepository(context: context),
                    session: SessionDatabaseRepository(context: context),
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return RequestMagicLink(
            transaction: transaction,
            mailSender: NoopMailSender()
        )
    }

    func makeListMagicLinks() -> ListMagicLinks {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadMagicLink(
                    magicLink: MagicLinkDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return ListMagicLinks(authorizer: authorizer, query: query)
    }

    func makeGetMagicLink() -> GetMagicLink {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadMagicLink(
                    magicLink: MagicLinkDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return GetMagicLink(authorizer: authorizer, query: query)
    }

    func makeListCredential() -> ListCredential {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadCredentialLink(
                    credential: CredentialDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return ListCredential(authorizer: authorizer, query: query)
    }

    func makeGetCredential() -> GetCredential {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadCredentialLink(
                    credential: CredentialDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return GetCredential(authorizer: authorizer, query: query)
    }

    func makeAddCredential() -> AddCredential {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context)
                )
            }
        )
        return AddCredential(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }

    func makeEditCredential() -> EditCredential {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context)
                )
            }
        )
        return EditCredential(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }

    func makeRemoveCredential() -> RemoveCredential {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context)
                )
            }
        )
        return RemoveCredential(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListIdentitySessions() -> ListIdentitySessions {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadSession(
                    session: SessionDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return ListIdentitySessions(authorizer: authorizer, query: query)
    }

    func makeGetSession() -> GetSession {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadSession(
                    session: SessionDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return GetSession(authorizer: authorizer, query: query)
    }

    func makeRemoveSession() -> RemoveSession {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteSession(
                    session: SessionDatabaseRepository(context: context)
                )
            }
        )
        return RemoveSession(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeAddMagicLink() -> AddMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMagicLink(
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return AddMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeEditMagicLink() -> AuthApplication.EditMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMagicLink(
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return AuthApplication.EditMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeRemoveMagicLink() -> RemoveMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteMagicLink(
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return RemoveMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListRolePermissions() -> ListRolePermissions {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                AuthScope(
                    identity: IdentityDatabaseQueries(
                        context: context
                    ),
                    rolePermissions: RolePermissionDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return ListRolePermissions(authorizer: authorizer, query: query)
    }

    func makeAddRolePermission() -> AddRolePermission {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRolePermissions(
                    rolePermissions: RolePermissionDatabaseRepository(
                        context: context
                    )
                )
            }
        )
        return AddRolePermission(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeRemoveRolePermission() -> RemoveRolePermission {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRolePermissions(
                    rolePermissions: RolePermissionDatabaseRepository(
                        context: context
                    )
                )
            }
        )
        return RemoveRolePermission(
            authorizer: authorizer,
            transaction: transaction
        )
    }

}
