public import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import MediaBackend
import SystemInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeListPublicTags() -> Public.Tag.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Tag.List.Scope(
                    tag: Public.Tag.List.Query.Database(context: context),
                    metadata: WebModule.Metadata.Reference.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
