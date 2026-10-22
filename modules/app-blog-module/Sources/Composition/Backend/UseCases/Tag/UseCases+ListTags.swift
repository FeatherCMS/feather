public import BlogApplication
import BlogInfrastructure
public import BlogModule
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import MediaBackend
import SystemInfrastructure
import WebDomain
import WebInfrastructure

extension UseCases {

    public func makeListTags() -> Tag.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Tag.List.Scope(
                    tag: Tag.List.Query.Database(
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
