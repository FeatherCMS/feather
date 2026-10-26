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

    func makeResolveWebRoute() -> WebRoute.Resolve.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WebRoute.Resolve.Scope(
                    metadata: WebRoute.Resolve.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
