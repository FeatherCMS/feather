import FeatherApplication
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import FeatherModuleKit
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    func makeListPublicMetadata() -> Public.Metadata.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Public.Metadata.List.Scope(
                    metadata: Public.Metadata.List.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
