import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension UseCases {
    func makeDetailJob() -> SystemModule.Job.Detail.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    SystemModule.Job.Detail.Scope(
                        job: SystemModule.Job.Detail.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
