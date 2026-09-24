import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeListJobs() -> ListJobs {
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
