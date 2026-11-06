import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension UseCases {
    func makeSearchJobs() -> SystemModule.Job.Search.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    SystemModule.Job.Search.Scope(
                        job: SystemModule.Job.Search.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
