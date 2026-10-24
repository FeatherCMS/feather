import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {
    public func makeResolvePublicArticles() -> Public.Article.Resolve.UseCase {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Public.Article.Resolve.Scope(
                        article: Public.Article.Resolve.Query.Database(
                            context: context
                        ),
                        articleCategoryIDs: Public.Article.CategoryIDs.Query
                            .Database(context: context),
                        metadataDetails: WebModule.Metadata.Resolve.Detail.Query
                            .Database(
                                context: context
                            )
                    )
                }
            )
        )
    }
}
