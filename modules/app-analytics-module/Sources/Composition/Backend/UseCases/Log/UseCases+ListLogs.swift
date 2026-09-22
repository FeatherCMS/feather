import AnalyticsApplication
import AnalyticsInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeListLogs() -> ListLogs {
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
