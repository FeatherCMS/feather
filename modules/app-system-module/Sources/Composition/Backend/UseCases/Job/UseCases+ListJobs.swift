import SystemModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeListJobs() -> SystemModule.Job.List.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    SystemModule.Job.List.Scope(
                        job: SystemModule.Job.List.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
