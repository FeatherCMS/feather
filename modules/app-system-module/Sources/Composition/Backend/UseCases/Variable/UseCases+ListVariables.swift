import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeListVariables() -> ListVariables {
        let query = DatabaseQueryExecutor(
            database: database,
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
