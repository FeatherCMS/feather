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

    func makeListPublicMetadata() -> WebApplication.Public.Metadata.List.UseCase
    {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WebApplication.Public.Metadata.List.Scope(
                    metadata: WebApplication.Public.Metadata.List.Query
                        .Database(
                            context: context
                        )
                )
            }
        )
        return .init(query: query)
    }
}
