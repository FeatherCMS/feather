import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import NewsModule
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeDetailPublicArticle()
        -> NewsApplication.Public.Article.Detail.UseCase
    {
        NewsApplication.Public.Article.Detail.UseCase(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    NewsApplication.Public.Article.Detail.Scope(
                        article: NewsModule.Article.Detail.Query.Database(
                            context: context,
                            metadata: WebModule.Metadata.Reference.Query
                                .Database(
                                    context: context
                                )
                        ),
                        category: NewsApplication.Public.Article.Detail.Query
                            .Database(
                                context: context,
                                metadata: WebModule.Metadata.Resolve.Detail
                                    .Query
                                    .Database(context: context)
                            )
                    )
                }
            )
        )
    }
}
