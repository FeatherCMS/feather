import AnalyticsApplication
import AnalyticsInfrastructure
import Application
import Infrastructure
import RedirectApplication
import RedirectInfrastructure

struct RedirectModule: Sendable {

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
        permissions += RedirectPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

extension RedirectModule {

    func makeGetPublicRuleBySource() -> GetPublicRuleBySource {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadRule(
                    rule: DatabaseRuleQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeAddRule() -> AddRule {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteRule(
                    rule: DatabaseRuleRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetRule() -> GetRule {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadRule(
                    rule: DatabaseRuleQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditRule() -> EditRule {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteRule(
                    rule: DatabaseRuleRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeListRules() -> ListRules {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadRule(
                    rule: DatabaseRuleQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeRemoveRule() -> RemoveRule {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteRule(
                    rule: DatabaseRuleRepository(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetNotFoundOverview() -> GetRedirectNotFoundOverview {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadLog(
                    log: DatabaseLogQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
