import SystemModule
import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import SystemApplication
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
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
                    )
                )
            }
        )
        return RequestMagicLink(
            transaction: transaction,
            jobs: jobs
        )
    }
}
