import Application
import AuthApplication
import AuthInfrastructure
import Infrastructure
import SystemApplication
import UserApplication
import UserInfrastructure

struct AuthModule: Sendable {
    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
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

extension AuthModule {

    func makeTokenAuth() -> TokenAuth {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuth(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    session: DatabaseSessionRepository(
                        connection: connection
                    ),
                    magicLink: DatabaseMagicLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return TokenAuth(
            transaction: transaction,
            clock: DefaultClock()
        )
    }

    func makeSignInWithCredentials() -> SignInWithCredentials {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuth(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    session: DatabaseSessionRepository(
                        connection: connection
                    ),
                    magicLink: DatabaseMagicLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return SignInWithCredentials(
            transaction: transaction,
            clock: DefaultClock(),
            idGenerator: NanoIDGenerator(),
            passwordHasher: BCryptPasswordHasher()
        )
    }

    func makeSignInWithMagicLink() -> SignInWithMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuth(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    session: DatabaseSessionRepository(
                        connection: connection
                    ),
                    magicLink: DatabaseMagicLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return SignInWithMagicLink(
            transaction: transaction,
            clock: DefaultClock(),
            idGenerator: NanoIDGenerator()
        )
    }

    func makeRequestMagicLink() -> RequestMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuth(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    session: DatabaseSessionRepository(
                        connection: connection
                    ),
                    magicLink: DatabaseMagicLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return RequestMagicLink(
            transaction: transaction,
            clock: DefaultClock(),
            idGenerator: infrastructure.idGenerator,
            mailSender: NoopMailSender()
        )
    }

    func makeListMagicLinks() -> ListMagicLinks {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMagicLink(
                    magicLink: DatabaseMagicLinkQueries(
                        connection: connection
                    )
                )
            }
        )
        return ListMagicLinks(authorizer: authorizer, query: query)
    }

    func makeGetMagicLink() -> GetMagicLink {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadMagicLink(
                    magicLink: DatabaseMagicLinkQueries(
                        connection: connection
                    )
                )
            }
        )
        return GetMagicLink(authorizer: authorizer, query: query)
    }

    func makeListAccountSessions() -> ListAccountSessions {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadSession(
                    session: DatabaseSessionQueries(
                        connection: connection
                    )
                )
            }
        )
        return ListAccountSessions(authorizer: authorizer, query: query)
    }

    func makeGetSession() -> GetSession {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadSession(
                    session: DatabaseSessionQueries(
                        connection: connection
                    )
                )
            }
        )
        return GetSession(authorizer: authorizer, query: query)
    }

    func makeRemoveSession() -> RemoveSession {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteSession(
                    session: DatabaseSessionRepository(
                        connection: connection
                    )
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
            database: infrastructure.database,
            scope: { connection in
                WriteMagicLink(
                    magicLink: DatabaseMagicLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return AddMagicLink(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeEditMagicLink() -> AuthApplication.EditMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteMagicLink(
                    magicLink: DatabaseMagicLinkRepository(
                        connection: connection
                    )
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
            database: infrastructure.database,
            scope: { connection in
                WriteMagicLink(
                    magicLink: DatabaseMagicLinkRepository(
                        connection: connection
                    )
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
            database: infrastructure.database,
            scope: { connection in
                AuthScope(
                    account: DatabaseAccountQueries(
                        connection: connection
                    ),
                    rolePermissions: DatabaseRolePermissionQueries(
                        connection: connection
                    )
                )
            }
        )
        return ListRolePermissions(authorizer: authorizer, query: query)
    }

    func makeAddRolePermission() -> AddRolePermission {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteRolePermissions(
                    rolePermissions: DatabaseRolePermissionRepository(
                        connection: connection
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
            database: infrastructure.database,
            scope: { connection in
                WriteRolePermissions(
                    rolePermissions: DatabaseRolePermissionRepository(
                        connection: connection
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
