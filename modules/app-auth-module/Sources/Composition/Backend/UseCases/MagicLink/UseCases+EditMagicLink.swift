import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeEditMagicLink() -> MagicLink.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                MagicLink.Edit.Scope(
                    magicLink: MagicLink.Repository.Database(context: context)
                )
            }
        )
        return MagicLink.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
