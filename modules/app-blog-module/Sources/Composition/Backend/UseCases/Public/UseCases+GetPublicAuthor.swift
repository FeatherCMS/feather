public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeGetPublicAuthor() -> Public.Author.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Author.Detail.Scope(
                    author: Public.Author.Database(
                        context: context,
                        metadata: WebModule.Metadata.Query.Database(
                            context: context
                        )
                    ),
                    authorLink: Public.AuthorLink.Database(
                        context: context
                    ),
                    post: Public.Post.Database(
                        context: context,
                        metadata: WebModule.Metadata.Query.Database(
                            context: context
                        )
                    ),
                    metadata: WebModule.Metadata.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
