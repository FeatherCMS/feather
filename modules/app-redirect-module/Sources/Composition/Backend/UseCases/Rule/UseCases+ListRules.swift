import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure
import RedirectModule

extension UseCases {

    func makeListRules() -> Rule.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Rule.List.Scope(
                    query: Rule.List.Query.Database(
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
