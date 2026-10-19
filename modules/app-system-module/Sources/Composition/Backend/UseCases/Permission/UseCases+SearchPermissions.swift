import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension UseCases {
    func makeSearchPermissions() -> SystemModule.Permission.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Permission.Search.Scope(
                    permission: SystemModule.Permission.Search.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
