import FeatherInfrastructure
import RedirectApplication
import RedirectInfrastructure
import RedirectModule

extension UseCases {
    func makeDetailRule() -> Rule.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Rule.Detail.Scope(
                    query: Rule.Detail.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
