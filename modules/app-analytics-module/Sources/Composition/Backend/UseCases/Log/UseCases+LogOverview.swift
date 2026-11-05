import AnalyticsApplication
import AnalyticsDomain
import AnalyticsInfrastructure
import AnalyticsModule
import FeatherInfrastructure

extension UseCases {

    func makeLogOverview() -> Log.Overview.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Log.Overview.Scope(
                    query: Log.Overview.Query.Database(
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
