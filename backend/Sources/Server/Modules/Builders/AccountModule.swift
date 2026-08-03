import AccountApplication
import AccountInfrastructure
import Application
import Infrastructure

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

    func makeGetAccountSettings() -> GetAccountSettings {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAccountSettings(
                    settings: DatabaseAccountSettingsQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }

    func makeEditAccountSettings() -> EditAccountSettings {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAccountSettings(
                    queries: DatabaseAccountSettingsQueries(
                        connection: connection
                    ),
                    settings: DatabaseAccountSettingsRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
