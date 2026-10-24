public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeGetPublicTag() -> Public.Tag.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Tag.Detail.Scope(
                    tag: Public.Tag.Detail.Query.Database(
                        context: context,
                        metadata: WebModule.Metadata.Reference.Query.Database(
                            context: context
                        )
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
