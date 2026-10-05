import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import SystemInfrastructure

extension UseCases {

    func makeRequestMagicLink() -> RequestMagicLink {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
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
