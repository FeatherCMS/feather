import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeGetJob() -> GetJob {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
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
