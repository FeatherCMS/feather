import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserAdminAPI
import UserAppAPI
import UserApplication
import UserInfrastructure

public struct UserBackend: Sendable, UserAdminAPI.APIProtocol, UserAppAPI
        .APIProtocol
{
    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    private let authorizer: any Authorizer
    private let events: any EventPublisher

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        events: any EventPublisher
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.events = events
    }
}

extension UserBackend {

    func makeAddIdentity() -> AddIdentity {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteIdentity(
                    identity: IdentityDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            events: events
        )
    }

    public func makeGetIdentity() -> GetIdentity {
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

    func makeEditIdentity() -> EditIdentity {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteIdentityRole(
                    identity: IdentityDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListIdentities() -> ListIdentities {
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

    func makeRemoveIdentity() -> RemoveIdentity {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteIdentity(
                    identity: IdentityDatabaseRepository(context: context)
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
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRole(
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetRole() -> GetRole {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadRole(
                    role: RoleDatabaseQueries(
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

    func makeEditRole() -> EditRole {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRole(
                    role: RoleDatabaseRepository(context: context)
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
            database: database,
            scope: { context in
                ReadRole(
                    role: RoleDatabaseQueries(
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

    func makeRemoveRole() -> RemoveRole {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRole(
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

}
