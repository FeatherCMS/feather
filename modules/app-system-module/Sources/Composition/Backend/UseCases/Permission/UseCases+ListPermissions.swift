import SystemModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeListPermissions() -> SystemModule.Permission.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Permission.List.Scope(
                    permission: SystemModule.Permission.List.Query
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
