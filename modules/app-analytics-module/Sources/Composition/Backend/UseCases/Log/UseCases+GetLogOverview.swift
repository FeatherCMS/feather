import AnalyticsApplication
import AnalyticsInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeLogOverview() -> Log.Overview.UseCase {
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
