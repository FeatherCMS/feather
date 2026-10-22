import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeGetPublicArticle() -> GetPublicArticle {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    PublicNewsArticle.Detail.Scope(
                        article: ArticleDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        category: CategoryDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        )
                    )
                }
            )
        )
    }
}
