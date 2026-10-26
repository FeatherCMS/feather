import AnalyticsApplication
import AnalyticsDomain
import AnalyticsInfrastructure
import AnalyticsModule
import FeatherInfrastructure

extension UseCases {

    func makeDetailLog() -> Log.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Log.Detail.Scope(
                    query: Log.Detail.Query.Database(
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
