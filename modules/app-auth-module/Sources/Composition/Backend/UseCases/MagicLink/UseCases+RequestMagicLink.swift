import AuthAdminAPI
import AuthAppAPI
import AuthApplication
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import UserApplication
import UserBackend
import UserInfrastructure

extension UseCases {

    func makeRequestMagicLink() -> RequestMagicLink {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRequestMagicLink(
                    credential: CredentialDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(
                        context: context
                    ),
                    magicLink: MagicLinkDatabaseRepository(context: context),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return RequestMagicLink(
            transaction: transaction,
            mailSender: mailSender
        )
    }
}
