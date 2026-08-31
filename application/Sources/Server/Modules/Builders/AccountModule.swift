import FeatherContracts
import AccountApplication
import AccountInfrastructure
import FeatherApplication
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
            database: infrastructure.database,
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
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
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
