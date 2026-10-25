import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
public import NewsModule

extension UseCases {

    public func makeListArticles() -> Article.List.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Article.List.Scope(
                        article: Article.List.Query.Database(context: context)
                    )
                }
            )
        )
    }
}
