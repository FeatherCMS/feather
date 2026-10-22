public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeGetPublicTag() -> Public.Tag.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Tag.Detail.Scope(
                    tag: Public.Query.TagContent.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
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
