public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeGetPublicAuthor() -> Public.Author.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Author.Detail.Scope(
                    author: Public.Query.AuthorContent.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    ),
                    authorLink: Public.Query.AuthorLinkContent.Database(
                        context: context
                    ),
                    post: Public.Query.PostContent.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    ),
                    metadata: Metadata.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
