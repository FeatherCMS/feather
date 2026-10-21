import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeRemoveMagicLink() -> MagicLink.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MagicLink.Remove.Scope(
                    magicLink: MagicLink.Repository.Database(context: context)
                )
            }
        )
        return MagicLink.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
