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

    func makeDetailSettings() -> Settings.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Settings.Detail.Scope(
                    settings: Settings.Detail.Query.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
