public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import MediaBackend
import SystemInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {
    public func makeSearchPosts() -> Post.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Post.Search.Scope(
                    post: Post.Query.Database(
                        context: context,
                        metadata: Metadata.Query.Database(context: context)
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
