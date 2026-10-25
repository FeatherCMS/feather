import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import NewsModule
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeDetailPublicCategory() -> Public.Category.Detail.UseCase {
        Public.Category.Detail.UseCase(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Public.Category.Detail.Scope(
                        category: NewsModule.Category.Detail.Query.Database(
                            context: context,
                            metadata: WebModule.Metadata.Reference.Query
                                .Database(
                                    context: context
                                )
                        ),
                        article: Public.Category.Detail.Query.Database(
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
