import SystemModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeListVariables() -> SystemModule.Variable.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Variable.List.Scope(
                    variable: SystemModule.Variable.List.Query.Database(
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
