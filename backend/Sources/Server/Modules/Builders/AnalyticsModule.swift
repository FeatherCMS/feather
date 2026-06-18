import AnalyticsApplication
import AnalyticsInfrastructure
import Application
import Infrastructure

struct AnalyticsModule: Sendable {

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
        permissions += AnalyticsPermissions.allPermissions()

        for permission in permissions {
            print(permission.rawValue)
        }
    }
}

extension AnalyticsModule {

    func makeTrackLog() -> TrackLog {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteLog(
                    log: DatabaseLogRepository(connection: connection)
                )
            }
        )
        return .init(
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeListLogs() -> ListLogs {
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

    func makeGetLog() -> GetLog {
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

    func makeGetLogOverview() -> GetLogOverview {
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
