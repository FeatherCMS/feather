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

