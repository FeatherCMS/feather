import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure
import RedirectModule

extension UseCases {
    func makeResolveRule() -> Rule.Resolve.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Rule.Resolve.Scope(
                    query: Rule.Resolve.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
