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

    func makeGetPublicSettings() -> GetPublicSettings {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Settings.Repository.Scope(
                    settings: Settings.Repository.Database(context: context)
                )
            }
        )
        return .init(query: query)
    }
}
