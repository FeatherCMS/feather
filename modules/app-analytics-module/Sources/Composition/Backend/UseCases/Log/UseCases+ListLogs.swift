import AnalyticsApplication
import AnalyticsDomain
import AnalyticsInfrastructure
import AnalyticsModule
import FeatherInfrastructure

extension UseCases {

    func makeLogList() -> Log.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
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
