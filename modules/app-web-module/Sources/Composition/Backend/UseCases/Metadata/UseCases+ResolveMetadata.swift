import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebDomain
import WebApplication
import WebInfrastructure

extension UseCases {

    func makeResolveMetadata() -> ResolveMetadata {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Metadata.Query.Scope(
                    metadata: Metadata.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
