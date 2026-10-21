import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure
import RedirectModule

extension UseCases {
    func makeResolveRule() -> RedirectModule.Rule.Resolve.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                RedirectModule.Rule.Resolve.Scope(
                    query: RedirectModule.Rule.Resolve.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
