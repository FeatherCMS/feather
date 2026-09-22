import AnalyticsApplication
import AnalyticsInfrastructure
import FeatherInfrastructure

extension UseCases {

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
}
