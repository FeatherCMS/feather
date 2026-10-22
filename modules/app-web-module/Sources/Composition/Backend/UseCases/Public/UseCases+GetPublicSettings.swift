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

    func makeGetPublicSettings() -> Settings.Public.Detail.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Settings.Public.Detail.Scope(
                    settings: Settings.Repository.Database(context: context)
                )
            }
        )
        return .init(query: query)
    }
}
