import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension UseCases {
    func makeSearchVariables() -> SystemModule.Variable.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Variable.Search.Scope(
                    variable: SystemModule.Variable.Search.Database(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
