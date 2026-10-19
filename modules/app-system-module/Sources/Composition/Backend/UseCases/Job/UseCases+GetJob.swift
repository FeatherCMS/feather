import SystemModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeGetJob() -> SystemModule.Job.Detail.UseCase {
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
