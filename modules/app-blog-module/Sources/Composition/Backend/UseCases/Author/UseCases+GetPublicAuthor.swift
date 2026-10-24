public import BlogApplication
import BlogInfrastructure
import BlogModule
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
                    author: Public.Author.Detail.Query.Database(
                        context: context,
                        metadata: WebModule.Metadata.Reference.Query.Database(
                            context: context
                        )
                    ),
                    authorLink: AuthorLink.List.Query.Database(
                        context: context
                    ),
                    postDetail: Public.Post.Detail.Query.Database(
                        context: context,
                        metadata: WebModule.Metadata.Reference.Query.Database(
                            context: context
                        )
                    ),
                    postList: Public.Post.List.Query.Database(context: context),
                    metadata: WebModule.Metadata.Reference.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
