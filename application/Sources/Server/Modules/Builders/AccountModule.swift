import FeatherContracts
import AccountApplication
import AccountInfrastructure
import FeatherInfrastructure

struct AccountModule: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }
}

extension AccountModule {

    func makeGetSettings() -> GetSettings {
        let query = DatabaseQueryExecutor(
            databaseContext: infrastructure.databaseContext,
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

    func makeEditSettings() -> EditSettings {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: infrastructure.databaseContext,
            scope: { context in
                return WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
