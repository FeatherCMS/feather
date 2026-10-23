import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeListPublicCategories() -> Public.Category.List.UseCase {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Public.Category.List.Scope(
                        category: CategoryDatabaseQueries(
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
