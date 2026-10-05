import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeGetVariable() -> GetVariable {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadVariable(
                    variable: VariableDatabaseQueries(
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
