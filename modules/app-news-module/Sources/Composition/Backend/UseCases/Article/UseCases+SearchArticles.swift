import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule

extension UseCases {
    public func makeSearchArticles() -> Article.Search.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Article.Search.Scope(
                        article: Article.Search.Query.Database(context: context)
                    )
                }
            )
        )
    }
}
