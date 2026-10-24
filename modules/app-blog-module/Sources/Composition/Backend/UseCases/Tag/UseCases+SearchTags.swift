public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure

extension UseCases {
    public func makeSearchTags() -> Tag.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Tag.Search.Scope(
                    tag: Tag.Search.Query.Database(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
