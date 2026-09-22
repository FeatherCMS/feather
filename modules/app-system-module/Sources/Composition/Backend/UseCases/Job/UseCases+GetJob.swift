import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeGetJob() -> GetJob {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadJob(
                        job: JobDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
