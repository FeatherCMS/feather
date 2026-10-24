import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makePublicCategoryDetail() -> Public.Category.Detail.UseCase
    {
        Public.Category.Detail.UseCase(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Public.Category.Detail.Scope(
                        category: CategoryDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        article: ArticleDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        articleCategoryIDs: ArticleDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        metadataDetails: WebModule.Metadata.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
