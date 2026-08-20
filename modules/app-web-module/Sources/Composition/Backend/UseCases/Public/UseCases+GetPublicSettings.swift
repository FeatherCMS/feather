import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation
import SystemInfrastructure
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebInfrastructure

extension UseCases {

    func makeGetPublicSettings() -> GetPublicSettings {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    WriteSettings(
                        settings: SettingsDatabaseRepository(context: context)
                    )
                }
            )
            return .init(query: query)
        }
}

