public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {
    public func makeSearchAuthors() -> Author.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Author.Search.Scope(
                    author: Author.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
