import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import NewsModule
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeListPublicCategories()
        -> NewsApplication.Public.Category.List.UseCase
    {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    NewsApplication.Public.Category.List.Scope(
                        category: NewsApplication.Public.Category.List.Query
                            .Database(
                                context: context
                            ),
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
