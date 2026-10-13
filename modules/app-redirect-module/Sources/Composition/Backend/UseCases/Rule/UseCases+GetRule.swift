import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure

extension UseCases {

    func makeGetRule() -> GetRule {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadRule(
                    rule: RuleDatabaseQueries(
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
