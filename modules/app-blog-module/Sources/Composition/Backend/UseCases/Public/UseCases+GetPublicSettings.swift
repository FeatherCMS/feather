public import BlogApplication
import BlogInfrastructure
public import FeatherInfrastructure

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
