import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule

extension UseCases {

    func makeRequestMagicLink() -> MagicLink.Request.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MagicLink.Request.Scope(
                    credential: Credential.Repository.Database(
                        context: context
                    ),
                    authEmail: Email.Repository.Database(
                        context: context
                    ),
                    magicLink: MagicLink.Repository.Database(context: context),
                    variable: SystemModule.Variable.Lookup.Query.Database(
                        context: context
                    )
                )
            }
        )
        return MagicLink.Request.UseCase(
            transaction: transaction,
            jobs: jobs
        )
    }
}
