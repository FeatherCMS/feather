import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeGetSettings() -> AccountApplication.GetSettings {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadSettings(
                    settings: SettingsDatabaseQueries(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
