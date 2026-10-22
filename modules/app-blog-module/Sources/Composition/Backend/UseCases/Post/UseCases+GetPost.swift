public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeGetPost() -> Post.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Post.Detail.Scope(
                    post: Post.Detail.Query.Database(
                        context: context,
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
