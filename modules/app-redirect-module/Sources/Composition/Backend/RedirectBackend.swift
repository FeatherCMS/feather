import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import RedirectAdminAPI
import RedirectAppAPI
import RedirectApplication
import RedirectInfrastructure

public struct RedirectBackend: Sendable, RedirectAdminAPI.APIProtocol,
    RedirectAppAPI.APIProtocol
{

    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    private let authorizer: any Authorizer

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
        permissions += RedirectPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

extension RedirectBackend {

    func makeGetPublicRuleBySource() -> GetPublicRuleBySource {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadRule(
                    rule: RuleDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    func makeAddRule() -> AddRule {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRule(
                    rule: RuleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetRule() -> GetRule {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadRule(
                    rule: RuleDatabaseQueries(
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

    func makeEditRule() -> EditRule {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRule(
                    rule: RuleDatabaseRepository(context: context)
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
            database: database,
            scope: { context in
                ReadRule(
                    rule: RuleDatabaseQueries(
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

    func makeRemoveRule() -> RemoveRule {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRule(
                    rule: RuleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

}
