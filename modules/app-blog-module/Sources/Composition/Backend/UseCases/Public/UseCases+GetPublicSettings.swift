public import BlogApplication
import BlogInfrastructure
public import FeatherInfrastructure

extension UseCases {

    public func makeGetPublicSettings() -> DatabaseQueryExecutor<WriteSettings>
    {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
    }
}
