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

    public func makeGetTag() -> Tag.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Tag.Detail.Scope(
                    tag: Tag.Detail.Query.Database(
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
