import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeGetPublicAuthor() -> GetPublicAuthor {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadPublic(
                        post: PostDatabaseQueries(
                            context: context,
                            metadata: MetadataDatabaseQueries(
                                context: context
                            )
                        ),
                        author: AuthorDatabaseQueries(
                            context: context,
                            metadata: MetadataDatabaseQueries(
                                context: context
                            )
                        ),
                        tag: TagDatabaseQueries(
                            context: context,
                            metadata: MetadataDatabaseQueries(
                                context: context
                            )
                        ),
                        authorLink: AuthorLinkDatabaseQueries(
                            context: context
                        ),
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
            return .init(query: query)
        }
}

