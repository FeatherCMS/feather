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

extension UseCases {

    func makeListMetadata() -> Metadata.List.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Metadata.List.Scope(
                    metadata: Metadata.List.Query.Database(
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
