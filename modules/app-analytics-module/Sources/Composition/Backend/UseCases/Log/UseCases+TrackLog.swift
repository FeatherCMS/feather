import AnalyticsApplication
import AnalyticsDomain
import AnalyticsInfrastructure
import AnalyticsModule
import FeatherInfrastructure

extension UseCases {

    func makeLogTrack() -> Log.Track.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Log.Track.Scope(
                    log: Log.Repository.Database(context: context)
                )
            }
        )
        return .init(
            transaction: transaction
        )
    }
}
