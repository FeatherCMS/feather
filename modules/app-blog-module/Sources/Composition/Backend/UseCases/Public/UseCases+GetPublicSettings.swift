import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeGetPublicSettings() -> DatabaseQueryExecutor<WriteSettings>
    {
        DatabaseQueryExecutor(
            database: database,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
    }
}
