public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeGetPublicTag() -> Public.Tag.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Query.Scope(
                    post: Public.Query.PostContent.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    ),
                    author: Public.Query.AuthorContent.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    ),
                    tag: Public.Query.TagContent.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    ),
                    authorLink: Public.Query.AuthorLinkContent.Database(
                        context: context
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
