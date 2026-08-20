import AnalyticsAdminAPI
import AnalyticsAppAPI
import AnalyticsApplication
import AnalyticsInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension UseCases {

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

