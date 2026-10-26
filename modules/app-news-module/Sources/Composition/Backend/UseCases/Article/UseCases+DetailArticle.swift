import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebInfrastructure
import WebModule
public import NewsModule

extension UseCases {

    public func makeDetailArticle() -> Article.Detail.UseCase {
        .init(
            authorizer: authorizer,
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Article.Detail.Scope(
                        article: Article.Detail.Query.Database(
                            context: context,
                            metadata: WebModule.Metadata.Reference.Query.Database(
                                context: context
                            )
                        )
                    )
                }
            )
        )
    }
}
