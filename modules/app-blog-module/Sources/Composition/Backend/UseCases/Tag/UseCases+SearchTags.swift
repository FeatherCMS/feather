public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {
    public func makeSearchTags() -> Tag.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Tag.Search.Scope(
                    tag: Tag.Query.Database(
                        context: context,
                        metadata: Metadata.Query.Database(context: context)
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
