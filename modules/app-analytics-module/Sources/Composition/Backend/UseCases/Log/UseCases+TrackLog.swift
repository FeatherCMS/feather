import AnalyticsApplication
import AnalyticsInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeLogTrack() -> Log.Track.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
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
}
