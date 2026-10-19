public import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherModuleKit
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeGetSettings() -> GetSettings {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }
}
