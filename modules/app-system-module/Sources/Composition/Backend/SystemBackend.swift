import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemAdminAPI
import SystemAppAPI
import SystemApplication
import SystemInfrastructure

public struct SystemBackend: Sendable, SystemAdminAPI.APIProtocol, SystemAppAPI
        .APIProtocol
{

    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    public let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
    }

    func aggregatedPermissions() {
        var permissions: [PermissionKey] = []
        permissions += SystemPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

extension SystemBackend {
    func makeAddPermission() -> AddPermission {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WritePermission(
                    permission: PermissionDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetPermissions() -> GetPermission {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadPermission(
                    permission: PermissionDatabaseQueries(
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

    func makeEditPermission() -> EditPermission {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WritePermission(
                    permission: PermissionDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListPermissions() -> ListPermissions {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadPermission(
                    permission: PermissionDatabaseQueries(
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

    func makeRemovePermission() -> RemovePermission {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WritePermission(
                    permission: PermissionDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeAddVariable() -> AddVariable {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteVariable(
                    variable: VariableDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetVariable() -> GetVariable {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadVariable(
                    variable: VariableDatabaseQueries(
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

    func makeEditVariable() -> EditVariable {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteVariable(
                    variable: VariableDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListVariables() -> ListVariables {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadVariable(
                    variable: VariableDatabaseQueries(
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

    func makeListJobs() -> ListJobs {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadJob(
                        job: JobDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
        )
    }

    func makeGetJob() -> GetJob {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadJob(
                        job: JobDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
        )
    }

    func makeRemoveVariable() -> RemoveVariable {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteVariable(
                    variable: VariableDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
