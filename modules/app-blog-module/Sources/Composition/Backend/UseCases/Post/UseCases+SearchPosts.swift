public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherDatabase
import FeatherInfrastructure
import FeatherModuleKit
import MediaBackend
import SystemInfrastructure

extension UseCases {
    public func makeSearchPosts() -> Post.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Post.Search.Scope(
                    post: Post.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
