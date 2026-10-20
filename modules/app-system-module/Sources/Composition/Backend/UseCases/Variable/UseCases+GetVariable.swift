import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension UseCases {

    func makeGetVariable() -> SystemModule.Variable.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                SystemModule.Variable.Detail.Scope(
                    variable: SystemModule.Variable.Detail.Query.Database(
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
