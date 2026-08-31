import AccountAdminAPI
import AccountAppAPI
import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserApplication
import UserInfrastructure

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
