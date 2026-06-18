import Application
import Infrastructure
import SystemApplication
import SystemInfrastructure

struct SystemModule: Sendable {

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
        permissions += SystemPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

extension SystemModule {

    func makeGetPublicBlogRouteSettings() -> GetPublicBlogRouteSettings {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadVariable(
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeAddPermission() -> AddPermission {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePermission(
                    permission: DatabasePermissionRepository(
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

    func makeGetPermissions() -> GetPermission {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPermission(
                    permission: DatabasePermissionQueries(
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

    func makeEditPermission() -> EditPermission {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePermission(
                    permission: DatabasePermissionRepository(
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

    func makeListPermissions() -> ListPermissions {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPermission(
                    permission: DatabasePermissionQueries(
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

    func makeRemovePermission() -> RemovePermission {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePermission(
                    permission: DatabasePermissionRepository(
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

    func makeAddVariable() -> AddVariable {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteVariable(
                    variable: DatabaseVariableRepository(
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

    func makeGetVariable() -> GetVariable {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadVariable(
                    variable: DatabaseVariableQueries(
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

    func makeEditVariable() -> EditVariable {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteVariable(
                    variable: DatabaseVariableRepository(
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

    func makeListVariables() -> ListVariables {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadVariable(
                    variable: DatabaseVariableQueries(
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

    func makeRemoveVariable() -> RemoveVariable {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteVariable(
                    variable: DatabaseVariableRepository(
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
