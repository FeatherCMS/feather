import AnalyticsAdminAPI
import AnalyticsAppAPI
import AnalyticsApplication
import AnalyticsInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

public struct AnalyticsBackend: Sendable, AnalyticsAdminAPI.APIProtocol,
    AnalyticsAppAPI.APIProtocol
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
        permissions += AnalyticsPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

extension AnalyticsBackend {

    func makeTrackLog() -> TrackLog {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteLog(
                    log: LogDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            transaction: transaction
        )
    }

    func makeListLogs() -> ListLogs {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadLog(
                    log: LogDatabaseQueries(
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

    func makeGetLog() -> GetLog {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadLog(
                    log: LogDatabaseQueries(
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

    func makeGetLogOverview() -> GetLogOverview {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadLog(
                    log: LogDatabaseQueries(
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
}
