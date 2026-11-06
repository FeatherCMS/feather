import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension UseCases {
    func makeDetailPermissions() -> SystemModule.Permission.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Permission.Detail.Scope(
                    permission: SystemModule.Permission.Detail.Query
                        .Database(
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
