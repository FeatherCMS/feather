import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeListPublicCategories() -> ListPublicCategories {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    PublicNewsCategory.List.Scope(
                        category: CategoryDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        metadata: WebModule.Metadata.Query.Database(
                            context: context
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
