import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsApplication
import NewsInfrastructure
import SystemInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeGetPublicCategory() -> GetPublicCategory {
            .init(
                query: DatabaseQueryExecutor(
                    database: database,
                    scope: { context in
                        ReadPublicNewsCategory(
                            category: CategoryDatabaseQueries(
                                context: context,
                                metadata: MetadataDatabaseQueries(
                                    context: context
                                )
                            ),
                            article: ArticleDatabaseQueries(
                                context: context,
                                metadata: MetadataDatabaseQueries(
                                    context: context
                                )
                            ),
                            metadata: MetadataDatabaseQueries(
                                context: context
                            )
                        )
                    }
                )
            )
        }
}

