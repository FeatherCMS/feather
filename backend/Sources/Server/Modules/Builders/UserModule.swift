import Application
import UserApplication
import UserInfrastructure
import Infrastructure

struct UserModule: Sendable {
    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }
}

extension UserModule {

    func makeRegisterAccount() -> UserApplication.RegisterAccount {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAccount(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    role: DatabaseRoleRepository(
                        connection: connection
                    )
                )
            }
        )
        return UserApplication.RegisterAccount(
            transaction: transaction,
            idGenerator: infrastructure.idGenerator,
            passwordHasher: BCryptPasswordHasher()
        )
    }

    func makeAddAccount() -> AddAccount {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAccount(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    role: DatabaseRoleRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator,
            passwordHasher: BCryptPasswordHasher()
        )
    }

    func makeGetMyAccount() -> GetMyAccount {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAccount(
                    account: DatabaseAccountQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeGetAccount() -> GetAccount {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAccount(
                    account: DatabaseAccountQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditAccount() -> EditAccount {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAccount(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    role: DatabaseRoleRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }

    func makeListAccounts() -> ListAccounts {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAccount(
                    account: DatabaseAccountQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeRemoveAccount() -> RemoveAccount {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAccount(
                    account: DatabaseAccountRepository(
                        connection: connection
                    ),
                    role: DatabaseRoleRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeAddRole() -> AddRole {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteRole(
                    role: DatabaseRoleRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetRole() -> GetRole {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadRole(
                    role: DatabaseRoleQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditRole() -> EditRole {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteRole(
                    role: DatabaseRoleRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListRoles() -> ListRoles {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadRole(
                    role: DatabaseRoleQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeRemoveRole() -> RemoveRole {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteRole(
                    role: DatabaseRoleRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeAddInvitation() -> AddInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteInvitation(
                    invitation: DatabaseInvitationRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetInvitation() -> GetInvitation {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadInvitation(
                    invitation: DatabaseInvitationQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditInvitation() -> UserApplication.EditInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteInvitation(
                    invitation: DatabaseInvitationRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListInvitations() -> ListInvitations {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadInvitation(
                    invitation: DatabaseInvitationQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeRemoveInvitation() -> RemoveInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteInvitation(
                    invitation: DatabaseInvitationRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
